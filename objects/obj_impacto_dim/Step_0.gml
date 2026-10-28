if (r < r_max) {
    r += vel_r;
} else {
    vida_post--;
    if (vida_post <= 0) { instance_destroy(); exit; }
}

// --- DAÑO A GABY: solo cuando el anillo la toca ---
var oPlayer = obj_jugador;
if (r < r_max + vel_r && instance_exists(oPlayer)) {
    var _d = point_distance(x, y, oPlayer.x, (oPlayer.bbox_top + oPlayer.bbox_bottom) / 2);

    if (abs(_d - r) <= grosor / 2 + 12) {
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
                hsp = _dir_empuje * 5;
                vsp = -4;
            }
        }
    }
}