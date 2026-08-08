switch (estado) {
    case "ESPERANDO":
        // Si el jugador la toca, cambia a atrapando
        if (place_meeting(x, y, obj_jugador) && !obj_jugador.invincible) {
            estado = "ATRAPANDO";
            golpes_actuales = 0;
            dano_temporizador = 0; // Inicializamos el temporizador de daño
            
            with (obj_jugador) {
                is_caught = true;
                player_take_damage(1, false, 0); // Primer daño instantáneo al tocarla
            }
        }
        break;
        
    case "ATRAPANDO":
        with (obj_jugador) {
            if(!is_dead)
            {
            hsp = 0;
            vsp = 0;
            
            // Atraemos al jugador suavemente hacia el centro de la planta usando lerp
            x = lerp(x, other.x, 0.2);
            y = lerp(y, other.y, 0.2);
            
            // Daño gradual por tiempo (cada 60 frames / 1 segundo)
            other.dano_temporizador++;
            if (other.dano_temporizador >= 60) {
                other.dano_temporizador = 0;
                player_take_damage(1, false, 0); // Daño periódico mientras esté atrapado
            }
            }
        }
        
        // Detectamos si el jugador presiona botones para soltarse
        if (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("D")) || 
            keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_space) || 
            keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)) {
            
            golpes_actuales++;
        }
        
        // Si completa los golpes necesarios, se libera
        if (golpes_actuales >= golpes_necesarios) {
            estado = "ESPERANDO";
            
            with (obj_jugador) {
                is_caught = false;
                vsp = -6; // Salto para salir disparado
            }
        }
        break;
}