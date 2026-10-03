// Avanza siguiendo el relieve
x += hsp;

// Escalón pequeño: sube. Muro alto: la onda se detiene
var _p = 0;
while (place_meeting(x, y, obj_wall) && _p < 14) { y--; _p++; }
if (place_meeting(x, y, obj_wall)) {
    instance_destroy();
    exit;
}

// Baja hasta el suelo; si hay un pozo, salta el hueco
var _y0 = y;
_p = 0;
while (!place_meeting(x, y + 1, obj_wall) && _p < 24) { y++; _p++; }
if (!place_meeting(x, y + 1, obj_wall)) y = _y0;

image_yscale = lerp(image_yscale, 1, 0.3);

// Vida y límites del mapa
vida--;
if (vida < 20) image_alpha = vida / 20;
if (vida <= 0 || x < 0 || x > room_width) {
    instance_destroy();
    exit;
}

// --- DAÑO A GABY (no se destruye al golpearla) ---
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