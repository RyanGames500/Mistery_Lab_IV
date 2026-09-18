x += vel_viento * direccion_viento;

if (place_meeting(x, y, obj_jugador)) {
    with (obj_jugador) { 
        if (!is_dead && !is_transforming) {
            if (is_transformed && transform_type == 9) {
                if (!is_hit) {
                    is_hit = true;
                    image_index = 0;
                    image_speed = 1;
                    
                    var _dir = sign(other.x - x);
                    hsp = _dir * -7; 
                    player_take_damage(1, false, 1); 
                    x += _dir * -10;
                }
            } 
            else {
                global.hp -= 1;
                if (global.hp <= 0) {
                    is_dead = true;
                }
                invincible = true;
                alarm[2] = 90;
                
                is_transforming = true;
                is_transformed = false;
                hsp = 0;
                vsp = 0;
                image_index = 0;
                image_speed = 1; 
                
                transform_type = 9;
                sprite_index = spr_gaby_avion_transformando;
                
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

if (x < 0 || x > room_width || place_meeting(x, y, obj_wall)) {
    instance_destroy();
}