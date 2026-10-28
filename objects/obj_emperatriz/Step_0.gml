var oPlayer = obj_jugador;

// --- Espera a que Gaby se acerque y presenta al jefe ---
if (!activada) {
    if (!instance_exists(oPlayer) || point_distance(x, y, oPlayer.x, oPlayer.y) > 400) exit;
    activada = true;
}
if (!intro_hecha) {
    intro_hecha = true;
    with (obj_camera) iniciar_cine(other.x-132, other.y-64, 1.6, 150, "Emperatriz Material");
}
if (global.cinematica) exit;
if (muerta) exit;

if (timer > 0) timer--;
if (cooldown > 0) cooldown--;
if (inv_timer > 0) inv_timer--;
temblor = 0;
image_blend = c_white;
choco = false;

// Fase 2
if (fase == 1 && hp <= hp_max * 0.5) {
    fase = 2;
    screen_shake(6);
    cooldown = 40;
}

// --- MÁQUINA DE ESTADOS ---
switch (estado) {

    case ESTADO_EMP.ACECHA:
        brazo = lerp(brazo, 0, 0.2);
        if (instance_exists(oPlayer)) dir = (oPlayer.x > x) ? 1 : -1;

        // Camina lento hacia Gaby, sin caerse a los pozos
        var _suelo_ad = collision_line(x + dir * 40, y - 4, x + dir * 40, y + 40, obj_wall, false, true) != noone;
        var _lejos = instance_exists(oPlayer) && abs(oPlayer.x - x) > 110;
        hsp = (_lejos && _suelo_ad) ? dir * vel_acecho : 0;

        // Elige un ataque distinto al anterior
        if (cooldown <= 0 && instance_exists(oPlayer)) {
            var _a = irandom(2);
            if (_a == ultimo_ataque) _a = (_a + 1 + irandom(1)) mod 3;
            ataque_actual = _a;
            ultimo_ataque = _a;

            var _rapido = (fase == 2) ? 0.75 : 1;
            if (_a == 0)      aviso_total = round(55 * _rapido);
            else if (_a == 1) aviso_total = round(50 * _rapido);
            else              aviso_total = round(60 * _rapido);

            estado = ESTADO_EMP.AVISO;
            timer = aviso_total;
            hsp = 0;
        }
        break;

    case ESTADO_EMP.AVISO:
        hsp = 0;
        if (instance_exists(oPlayer)) dir = (oPlayer.x > x) ? 1 : -1;

        temblor = 1 + (1 - timer / aviso_total) * 2;
        if (timer mod 8 < 4) image_blend = make_color_rgb(255, 190, 150);

        if (ataque_actual == 0) brazo = lerp(brazo, 1, 0.2);

        // Carga: fija la dirección 25 frames antes (se ve la línea)
        if (ataque_actual == 2 && timer == 25 && instance_exists(oPlayer)) {
            carga_dir = (oPlayer.x > x) ? 1 : -1;
        }

        if (timer <= 0) {
            if (ataque_actual == 0) {
                // MARTILLO: golpea y salen las ondas
                estado = ESTADO_EMP.MARTILLO;
                timer = (fase == 2) ? 70 : 45;
                brazo = 0;
                screen_shake(7);
                crear_ondas();
                onda2_timer = (fase == 2) ? 24 : -1;
            }
            else if (ataque_actual == 1) {
                // NÚCLEO
                estado = ESTADO_EMP.NUCLEO;
                nucleo_total = (fase == 2) ? nucleo_dur + 40 : nucleo_dur;
                timer = nucleo_total;
            }
            else {
                // CARGA
                estado = ESTADO_EMP.CARGA;
                carga_vel = 3;
                timer = 120;
            }
        }
        break;

    case ESTADO_EMP.MARTILLO:
        hsp = 0;
        // Segunda onda en fase 2
        if (onda2_timer > 0) {
            onda2_timer--;
            if (onda2_timer == 0) {
                crear_ondas();
                screen_shake(5);
            }
        }
        if (timer <= 0) {
            estado = ESTADO_EMP.CANSADA;
            timer = (fase == 2) ? 45 : 70;
        }
        break;

    case ESTADO_EMP.NUCLEO:
        hsp = 0;
        if (instance_exists(oPlayer)) {
            dir = (oPlayer.x > x) ? 1 : -1;

            var _cy = y - 48;
            var _py = (oPlayer.bbox_top + oPlayer.bbox_bottom) / 2;
            var _dx = oPlayer.x - x;

            // El campo se corta si hay un muro en medio (el relieve protege)
            var _en = abs(_dx) <= rango_nucleo
                   && abs(_py - _cy) <= alto_nucleo
                   && !collision_line(x, _cy, oPlayer.x, _py, obj_wall, false, true);

            if (_en && abs(_dx) > 40) {
                var _cerca = 1 - abs(_dx) / rango_nucleo;
                var _arr = min(1, (nucleo_total - timer) / 20);
                var _fmax = (fase == 2) ? fuerza_max * 1.2 : fuerza_max;
                var _f = lerp(fuerza_min, _fmax, _cerca) * _arr;
                var _m = -sign(_dx) * min(_f, abs(_dx) - 40);

                with (oPlayer) {
                    if (!place_meeting(x + _m, y, obj_wall)) {
                        x += _m;
                    } else {
                        var _s = sign(_m);
                        while (!place_meeting(x + _s, y, obj_wall)) x += _s;
                    }
                }
            }
        }

        // Daño si Gaby llega hasta ella
        if (place_meeting(x, y, oPlayer)) hacer_dano();

        if (timer <= 0) {
            estado = ESTADO_EMP.CANSADA;
            timer = (fase == 2) ? 45 : 70;
        }
        break;

    case ESTADO_EMP.CARGA:
        // Acelera
        var _vmax = (fase == 2) ? carga_vel_max * 1.15 : carga_vel_max;
        carga_vel = min(carga_vel + 0.35, _vmax);
        hsp = carga_dir * carga_vel;

        // Rompe bloques del escenario
        var _n = 0;
        var _b = instance_place(x + hsp, y, obj_bloque_destruible);
        while (_b != noone && _n < 10) {
            with (_b) instance_destroy();
            screen_shake(2);
            carga_vel = max(carga_vel * 0.8, 4);
            _n++;
            _b = instance_place(x + hsp, y, obj_bloque_destruible);
        }

        // Si se acaba el suelo (pozo), frena
        var _suelo_c = collision_line(x + carga_dir * 40, y - 4, x + carga_dir * 40, y + 40, obj_wall, false, true) != noone;
        if (!_suelo_c && place_meeting(x, y + 1, obj_wall)) {
            hsp = 0;
            estado = ESTADO_EMP.CANSADA;
            timer = 70;
        }

        // Daño al tocar a Gaby
        if (place_meeting(x, y, oPlayer)) hacer_dano();

        if (timer <= 0 && estado == ESTADO_EMP.CARGA) {
            hsp = 0;
            estado = ESTADO_EMP.CANSADA;
            timer = 60;
        }
        break;

    case ESTADO_EMP.ATURDIDA:
        hsp = 0;
        brazo = lerp(brazo, 0, 0.2);
        image_blend = (timer mod 12 < 6) ? c_white : make_color_rgb(190, 200, 215);

        if (timer <= 0) {
            image_blend = c_white;
            estado = ESTADO_EMP.ACECHA;
            cooldown = 40;
        }
        break;

    case ESTADO_EMP.CANSADA:
        hsp = 0;
        brazo = lerp(brazo, 0, 0.2);
        image_blend = make_color_rgb(210, 215, 225);

        if (timer <= 0) {
            image_blend = c_white;
            estado = ESTADO_EMP.ACECHA;
            cooldown = (fase == 1) ? 60 : 35;
        }
        break;
}

// --- FÍSICA ---
vsp += grav;

// Horizontal (sube escalones pequeños: rampas y piso irregular)
var _mx2 = hsp;
if (_mx2 != 0 && place_meeting(x + _mx2, y, obj_wall)) {
    var _subio = false;
    for (var s = 1; s <= 8; s++) {
        if (!place_meeting(x + _mx2, y - s, obj_wall)) {
            y -= s;
            _subio = true;
            break;
        }
    }
    if (_subio) {
        x += _mx2;
    } else {
        while (!place_meeting(x + sign(_mx2), y, obj_wall)) x += sign(_mx2);
        hsp = 0;
        choco = true;
    }
} else {
    x += _mx2;
}

// Vertical
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) y += sign(vsp);
    vsp = 0;
}
y += vsp;

// --- ¡Se estrelló contra un muro! ---
if (estado == ESTADO_EMP.CARGA && choco) {
    estado = ESTADO_EMP.ATURDIDA;
    timer = (fase == 1) ? 200 : 160;
    carga_vel = 0;
    screen_shake(10);
}