var oPlayer = obj_jugador;

// --- CONTROL DE EFECTOS GLOBALES (Stun / Miel) ---
if (stun_timer > 0) {
    stun_timer--;
    hsp = 0;
    vsp = 0;
    exit;
}

if (miel_timer > 0) {
    miel_timer--;
    hsp *= 0.5;
}

if (cooldown_ataque > 0) cooldown_ataque--;
if (timer > 0) timer--;

// Gravedad
var _en_suelo = place_meeting(x, y + 1, obj_wall);
if (!_en_suelo) vsp += grav; else vsp = 0;

// --- MÁQUINA DE ESTADOS ---
switch (estado) {

    case ESTADO_GUARDIANA.PATRULLA:
        image_blend = c_white;

        // Pausa al llegar a un extremo
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

        // Si hay vacío adelante, da la vuelta
        if (_en_suelo) {
            var _borde_x = (dir_patrulla == 1) ? bbox_right + 4 : bbox_left - 4;
            if (!position_meeting(_borde_x, bbox_bottom + 2, obj_wall)) {
                dir_patrulla *= -1;
                pausa = pausa_extremo;
            }
        }

        hsp = (pausa > 0) ? 0 : dir_patrulla * vel_patrulla;
        image_xscale = dir_patrulla;

        // Detección de Gaby: rango, altura similar y sin pared en medio
        if (cooldown_ataque <= 0 && instance_exists(oPlayer)) {
            var _dx = abs(x - oPlayer.x);
            var _dy = abs(y - oPlayer.y);
            var _ve = !collision_line(x, y - 8, oPlayer.x, oPlayer.y, obj_wall, false, true);

            if (_dx <= rango_vision && _dy < 80 && _ve) {
                dir_patrulla = (oPlayer.x > x) ? 1 : -1;
                image_xscale = dir_patrulla;
                hsp = 0;
                estado = ESTADO_GUARDIANA.AVISO;
                timer = tiempo_aviso;
            }
        }
        break;

    case ESTADO_GUARDIANA.AVISO:
        hsp = 0;

        // Parpadeo de advertencia
        image_blend = (timer mod 6 < 3) ? c_white : make_color_rgb(150, 200, 255);

        // Sigue mirando a Gaby
        if (instance_exists(oPlayer)) {
            dir_patrulla = (oPlayer.x > x) ? 1 : -1;
            image_xscale = dir_patrulla;
        }

        if (timer <= 0) {
            image_blend = c_white;

            // --- DISPARO ---
            var _p = instance_create_layer(x + dir_patrulla * 16, y - 8, layer, obj_proyectil_guardiana);
            _p.hsp = dir_patrulla * 3.5;
            _p.vsp = tiro_alto ? -5 : -2.5;
            tiro_alto = !tiro_alto;

            estado = ESTADO_GUARDIANA.DISPARO;
            timer = tiempo_retroceso;
            cooldown_ataque = cooldown_disparo;
        }
        break;

    case ESTADO_GUARDIANA.DISPARO:
        hsp = 0;
        image_blend = c_white;

        // Aquí puedes poner la animación de retroceso
        if (timer <= 0) {
            estado = ESTADO_GUARDIANA.PATRULLA; // continúa patrullando
        }
        break;
}

// --- COLISIONES HORIZONTALES ---
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) {
        x += sign(hsp);
    }
    hsp = 0;
    if (estado == ESTADO_GUARDIANA.PATRULLA) {
        dir_patrulla *= -1;
        pausa = pausa_extremo;
    }
}
x += hsp;

// --- COLISIONES VERTICALES ---
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;