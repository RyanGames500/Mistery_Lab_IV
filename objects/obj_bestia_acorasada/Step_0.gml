var oPlayer = obj_jugador;

// --- SÚPER ARMADURA: los golpes no la frenan mientras ataca ---
if (estado == ESTADO_BESTIA.ALERTA || estado == ESTADO_BESTIA.EMBESTIDA) {
    stun_timer = 0;
}

// --- STUN ---
if (stun_timer > 0) {
    stun_timer--;
    hsp = 0;
    vsp = 0;
    exit;
}

// --- MIEL (factor de velocidad que sí se aplica) ---
var _f = 1;
if (miel_timer > 0) {
    miel_timer--;
    _f = 0.5;
}

if (timer > 0) timer--;
if (cooldown_ataque > 0) cooldown_ataque--;

// Gravedad
if (!place_meeting(x, y + 1, obj_wall)) {
    vsp += grav;
} else {
    vsp = 0;
}

// --- MÁQUINA DE ESTADOS ---
switch (estado) {

    case ESTADO_BESTIA.PATRULLA:
        image_blend = c_white;
        if (pausa > 0) pausa--;

        // Límites de patrulla
        if (x > xstart + limite_patrulla && dir_patrulla == 1) {
            dir_patrulla = -1;
            pausa = pausa_extremo;
        }
        if (x < xstart - limite_patrulla && dir_patrulla == -1) {
            dir_patrulla = 1;
            pausa = pausa_extremo;
        }

        // No se cae de las plataformas
        if (place_meeting(x, y + 1, obj_wall)) {
            var _bx = (dir_patrulla == 1) ? bbox_right + 4 : bbox_left - 4;
            if (!position_meeting(_bx, bbox_bottom + 2, obj_wall)) {
                dir_patrulla *= -1;
                pausa = pausa_extremo;
            }
        }

        hsp = (pausa > 0) ? 0 : dir_patrulla * vel_patrulla;
        image_xscale = dir_patrulla;

        // Solo corre cuando VE a Gaby (rango, misma altura, sin pared en medio)
        if (cooldown_ataque <= 0 && instance_exists(oPlayer)) {
            var _dx = abs(x - oPlayer.x);
            var _dy = abs(y - oPlayer.y);
            var _ve = !collision_line(x, y - 8, oPlayer.x, oPlayer.y, obj_wall, false, true);

            if (_dx <= rango_vision && _dy < 48 && _ve) {
                hsp = 0;
                estado = ESTADO_BESTIA.ALERTA;
                timer = tiempo_alerta;
            }
        }
        break;

    case ESTADO_BESTIA.ALERTA:
        hsp = 0;

        // Sigue mirando a Gaby hasta el último momento
        if (instance_exists(oPlayer)) {
            dir_patrulla = (oPlayer.x > x) ? 1 : -1;
            image_xscale = dir_patrulla;
        }

        // Aviso: parpadeo rojizo
        image_blend = (timer mod 8 < 4) ? c_white : make_color_rgb(255, 170, 150);

        if (timer <= 0) {
            image_blend = c_white;
            estado = ESTADO_BESTIA.EMBESTIDA;   // la dirección queda fijada AHORA
            timer = embestida_max;
        }
        break;

    case ESTADO_BESTIA.EMBESTIDA:
        hsp = dir_patrulla * vel_embestida;

        // Si se acaba el suelo o el tiempo, frena (no corre para siempre)
        var _fx = (dir_patrulla == 1) ? bbox_right + 8 : bbox_left - 8;
        var _borde = place_meeting(x, y + 1, obj_wall) && !position_meeting(_fx, bbox_bottom + 2, obj_wall);

        if (timer <= 0 || _borde) {
            hsp = 0;
            estado = ESTADO_BESTIA.REPOSO;
            timer = tiempo_derrape;
        }
        break;

    case ESTADO_BESTIA.REPOSO:
        hsp = 0;

        // Si chocó con la pared se ve aturdida
        if (timer > tiempo_derrape) {
            image_blend = (timer mod 10 < 5) ? c_white : make_color_rgb(200, 220, 255);
        } else {
            image_blend = c_white;
        }

        if (timer <= 0) {
            image_blend = c_white;
            dir_patrulla *= -1;
            estado = ESTADO_BESTIA.PATRULLA;
            cooldown_ataque = 60;
        }
        break;
}

// --- COLISIONES HORIZONTALES ---
var _mx = hsp * _f;
if (place_meeting(x + _mx, y, obj_wall)) {
    while (!place_meeting(x + sign(_mx), y, obj_wall)) {
        x += sign(_mx);
    }

    if (estado == ESTADO_BESTIA.EMBESTIDA) {
        // ¡Se estrelló! Larga ventana de castigo
        hsp = 0;
        estado = ESTADO_BESTIA.REPOSO;
        timer = tiempo_recuperacion_carga;
        screen_shake(6);
    } else {
        hsp = 0;
        dir_patrulla *= -1;
        if (estado == ESTADO_BESTIA.PATRULLA) pausa = pausa_extremo;
    }
} else {
    x += _mx;
}

// --- COLISIONES VERTICALES ---
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;

// --- DAÑO A GABY ---
if (instance_exists(oPlayer) && place_meeting(x, y, oPlayer)) {
    var _fuerte = (estado == ESTADO_BESTIA.EMBESTIDA);

    with (oPlayer) {
        if (!is_dead && !is_transforming && !invincible) {
            player_take_damage(1, false, 1);
            if (global.hp <= 0) {
                is_dead = true;
            }
            invincible = true;
            alarm[2] = 90;

            var _dir_empuje = sign(x - other.x);
            if (_dir_empuje == 0) _dir_empuje = 1;
            hsp = _dir_empuje * (_fuerte ? 6 : 3);
            vsp = _fuerte ? -4 : -3;
        }
    }
}