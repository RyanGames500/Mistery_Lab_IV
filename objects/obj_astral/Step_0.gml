if (aviso > 0) {
    // Aviso: vibra sin hacer daño
    aviso--;
    x += choose(-0.6, 0.6);
    if (aviso <= 0) image_alpha = 1;
    exit;
}

// Cae acelerando
vsp = min(vsp + 0.25, vsp_max);
y += vsp;

// Se destruye contra plataformas o fuera del mapa
if (place_meeting(x, y, obj_wall) || y > room_height + 50) {
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
            vsp = -2;
        }
    }
    instance_destroy();
}