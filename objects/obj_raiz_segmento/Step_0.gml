timer--;

if (fase == 0) {
    // Aviso: asoma un poquito y tiembla
    x += choose(-0.5, 0.5);
    if (timer <= 0) {
        fase = 1;
        timer = 30;
        image_blend = c_white;
    }
} else {
    // Brota rápido hasta su tamaño completo
    image_yscale = lerp(image_yscale, 1, 0.4);

    // Se desvanece al final
    if (timer < 10) image_alpha = timer / 10;

    if (timer <= 0) instance_destroy();
}


// --- DAÑO A GABY ---
if (fase == 1) {
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

                // Empuje: hacia arriba y hacia el lado contrario de la raíz
                var _dir_empuje = sign(x - other.x);
                if (_dir_empuje == 0) _dir_empuje = 1;
                hsp = _dir_empuje * 3;
                vsp = -4; // un poco más fuerte que el proyectil, la raíz sale desde el suelo
            }
        }
    }
}