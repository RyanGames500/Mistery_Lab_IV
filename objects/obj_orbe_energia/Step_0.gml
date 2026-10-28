x += vel_orbe * direc;
var oPlayer = obj_jugador;

if (instance_exists(oPlayer) && place_meeting(x, y, oPlayer)) {
    with (oPlayer) {
        if (!is_dead && !is_transforming && !invincible) {

            // CASO A: si ya es Hada, daño normal con empuje
            if (is_transformed && transform_type == 11) {
                player_take_damage(1, false, 1);
                var _dir = sign(other.x - x);
                hsp = _dir * -7;
                x += _dir * -10;
            }
            // CASO B: se transforma (resta vida directo y arranca la TF)
            else {
                global.hp -= 1;
                if (global.hp <= 0) { is_dead = true; }

                invincible = true;
                alarm[2] = 90;

                is_transforming = true;
                is_transformed = false;
                hsp = 0;
                vsp = 0;
                image_index = 0;
                image_speed = 1;

                transform_type = 11;
                sprite_index = spr_gaby_hada_transformando;   // cambia por tu sprite

                if (variable_global_exists("galeria_items")) {
                    if (transform_type < array_length(global.galeria_items)) {
                        global.galeria_items[transform_type].unlocked = true;
                        if (script_exists(asset_get_index("guardar_galeria"))) {
                            guardar_galeria();
                        }
                    }
                }
            }
        }
    }
    instance_destroy();
}

if (x < 0 || x > room_width) {
    instance_destroy();
}