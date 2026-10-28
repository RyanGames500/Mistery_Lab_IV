// Movimiento a ras de suelo
if (place_meeting(x + hsp, y, obj_wall)) {
    instance_destroy();
    exit;
}
x += hsp;

// Se desvanece y desaparece
vida--;
if (vida < 15) image_alpha = vida / 15;
if (vida <= 0) {
    instance_destroy();
    exit;
}

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
            vsp = -3;
        }
    }
}