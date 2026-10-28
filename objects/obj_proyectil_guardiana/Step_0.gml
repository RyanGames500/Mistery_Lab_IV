vsp += grav;

// Giro visual
image_angle += hsp * 4;

// Recupera la forma después del rebote (efecto de aplastado)
image_xscale = lerp(image_xscale, 1, 0.2);
image_yscale = lerp(image_yscale, 1, 0.2);

// --- COLISIÓN HORIZONTAL: se destruye contra paredes ---
if (place_meeting(x + hsp, y, obj_wall)) {
    instance_destroy();
    exit;
}
x += hsp;

// --- COLISIÓN VERTICAL: rebota una vez en el suelo ---
if (place_meeting(x, y + vsp, obj_wall)) {
    var _v_impacto = vsp;

    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }

    if (_v_impacto > 0) {
        // Golpe contra el suelo
        if (rebotes_restantes > 0) {
            vsp = -max(_v_impacto * 0.85, 2);
            rebotes_restantes--;
            image_xscale = 1.4;
            image_yscale = 0.6;
        } else {
            instance_destroy();
            exit;
        }
    } else {
        // Golpe contra el techo
        vsp = 0;
    }
}
y += vsp;

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

// Vida y límites del mapa
vida--;
if (vida <= 0 || x < 0 || x > room_width || y > room_height) {
    instance_destroy();
}