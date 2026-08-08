switch (estado) {
    case "ESPERANDO":
        if (collision_rectangle(x - 38, y, x + 48, y + 200, obj_jugador, false, true)) {
            estado = "CAYENDO";
        }
        break;
        
    case "CAYENDO":
        if (!place_meeting(x, y + vel_caida, obj_wall)) {
            y += vel_caida;
        } else {
            while (!place_meeting(x, y + sign(vel_caida), obj_wall)) {
                y += sign(vel_caida);
            }
            screen_shake(6);
            estado = "SUBIENDO";
        }
        break;
        
    case "SUBIENDO":
        y -= vel_subida;
        if (y <= startY) {
            y = startY;
            estado = "ESPERANDO";
        }
        break;
}

if (place_meeting(x, y, obj_jugador) && !obj_jugador.invincible && estado == "CAYENDO") {
    with (obj_jugador) {
        if (!is_dead) {
            var _en_suelo = place_meeting(x, y + 1, obj_wall);
            
            if (_en_suelo) {
                player_take_damage(2, false, 0);
                is_hit = true;
                hsp = 0;
                vsp = 0;
            } else {
                player_take_damage(2, false, 0);
                is_hit = true;
                image_index = 0;
                hsp = 0;
                vsp = 12;
            }
        }
    }
}