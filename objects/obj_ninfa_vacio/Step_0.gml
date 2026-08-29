var oPlayer = obj_jugador;

if (instance_exists(oPlayer)) {
    var _dist = distance_to_object(oPlayer);
    
    switch (estado) {
        case ESTADO_NINFA.INACTIVA:
            timer_ataque++;
            
            if (!variable_instance_exists(id, "angulo_flotar")) {
                angulo_flotar = random(360);
                y_inicial = y;
            }
            angulo_flotar += 0.04;
            y = y_inicial + (sin(angulo_flotar) * 2);
            
            if (_dist <= rango_deteccion && timer_ataque >= intervalo_ataque) {
                timer_ataque = 0;
                duracion_desvanecer = 30;
                estado = ESTADO_NINFA.DESAPARECER;
            }
            break;
            
        case ESTADO_NINFA.DESAPARECER:
            image_alpha = lerp(image_alpha, 0, 0.15);
            duracion_desvanecer--;
            if (duracion_desvanecer <= 0) {
                x = oPlayer.x;
                y = oPlayer.y - 180;
                y_inicial = y;
                vsp = 0;
                estado = ESTADO_NINFA.TELETRANSPORTAR;
            }
            break;
            
        case ESTADO_NINFA.TELETRANSPORTAR:
            image_alpha = lerp(image_alpha, 1, 0.2);
            if (image_alpha >= 0.9) {
                estado = ESTADO_NINFA.CAER;
            }
            break;
            
        case ESTADO_NINFA.CAER:
            vsp = velocidad_caida;
            y += vsp;
            
            if (place_meeting(x, y, oPlayer)) {
                with (oPlayer) {
                    if (!is_hit && !is_dead) {
                        is_hit = true;
                        image_index = 0;
                        var _dir = sign(other.x - x);
                        hsp = _dir * -6;
                        vsp = -4;
                        player_take_damage(1, false, 1);
                    }
                }
            }
            
            if (place_meeting(x, y + 1, obj_wall)) {
                timer_ataque = 60; 
                y_inicial = y;
                estado = ESTADO_NINFA.INACTIVA;
            }
            break;
    }
}