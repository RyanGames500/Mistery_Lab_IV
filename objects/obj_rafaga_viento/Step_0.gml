
x += vel_viento * direccion_viento;

if (place_meeting(x, y, obj_jugador)) {
                with (obj_jugador) { 
                    if (!is_hit) {
                        if (!is_dead) {
                            is_hit = true;
                            image_index = 0;
                            var _dir = sign(other.x - x);
                            hsp = _dir * -7; 
                            player_take_damage(1, false, 1);
                            x += _dir * -10;
                            electrificado_timer = 45; 
                        }
                    }         
                }
    instance_destroy();
}

if (x < 0 || x > room_width || place_meeting(x, y, obj_wall)) {
    instance_destroy();
}