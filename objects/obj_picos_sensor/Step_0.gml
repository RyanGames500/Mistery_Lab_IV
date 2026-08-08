switch (estado) {
    case "OCULTO":
        y = startY;
        cronometro++;
        if (cronometro >= tiempo_oculto) {
            cronometro = 0;
            estado = "SUBIENDO";
        }
        break;
        
    case "SUBIENDO":
        y = lerp(y, targetY, 0.2);
        // Comprobación instantánea de colisión mientras sube
        if (place_meeting(x, y, obj_jugador) && !obj_jugador.invincible) {
            with (obj_jugador) {
                player_take_damage(1, false, 0);
                is_hit = true;
                hsp = sign(x - other.x) * 12;
                vsp = -5;
            }
        }
        if (abs(y - targetY) < 1) {
            y = targetY;
            estado = "VISIBLE";
            cronometro = 0;
        }
        break;
        
    case "VISIBLE":
        // Comprobación instantánea de colisión mientras está arriba
        if (place_meeting(x, y, obj_jugador) && !obj_jugador.invincible) {
            with (obj_jugador) {
                player_take_damage(1, false, 0);
                is_hit = true;
                hsp = sign(x - other.x) * 12;
                vsp = -5;
            }
        }
        cronometro++;
        if (cronometro >= tiempo_visible) {
            cronometro = 0;
            estado = "BAJANDO";
        }
        break;
        
    case "BAJANDO":
        y = lerp(y, startY, 0.2);
        if (abs(y - startY) < 1) {
            y = startY;
            estado = "OCULTO";
            cronometro = 0;
        }
        break;
}