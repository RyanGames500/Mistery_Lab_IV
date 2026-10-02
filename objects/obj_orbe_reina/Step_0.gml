// Aviso: parpadea en el borde sin moverse ni dañar
if (aviso > 0) {
    aviso--;
    image_alpha = (aviso mod 4 < 2) ? 0.4 : 0.8;
    if (aviso <= 0) image_alpha = 1;
    exit;
}

// Cruza la arena lento
x += hsp;

// Pulso visual
var _p = 1 + 0.1 * sin(current_time * 0.012);
image_xscale = _p;
image_yscale = _p;

// --- DAÑO A GABY ---
var oPlayer = obj_jugador;
if (instance_exists(oPlayer) && place_meeting(x, y, oPlayer)) {
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
            hsp = _dir_empuje * 3;
            vsp = -2;
        }
    }
    instance_destroy();
    exit;
}

// Se destruye al salir de la pantalla o por tiempo
var _cx = camera_get_view_x(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
vida--;
if (vida <= 0 || x < _cx - 80 || x > _cx + _cw + 80) {
    instance_destroy();
}