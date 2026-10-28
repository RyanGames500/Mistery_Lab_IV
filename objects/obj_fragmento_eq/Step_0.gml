sprite_index = (tipo == 0) ? global.spr_frag_materia : global.spr_frag_energia;
if (tipo == 0) image_angle += 4;

// Aviso: parpadea en el borde sin moverse ni dañar
if (aviso > 0) {
    aviso--;
    image_alpha = (aviso mod 4 < 2) ? 0.35 : 0.8;
    if (aviso <= 0) image_alpha = 1;
    exit;
}

x += lengthdir_x(vel_mov, dir_mov);
y += lengthdir_y(vel_mov, dir_mov);
vida++;

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

// Se destruye al salir de la pantalla
var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);
if (vida > 600 || x < _cx - 100 || x > _cx + _cw + 100 || y < _cy - 100 || y > _cy + _ch + 100) {
    instance_destroy();
}