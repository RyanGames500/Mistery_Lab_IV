angulo_flotar += velocidad_flotar;
y = y_inicial + (sin(angulo_flotar) * amplitud_flotar);
escala_visual = 1 + (cos(angulo_flotar * 2) * 0.1);
if (cooldown_descanso > 0) {
    cooldown_descanso--;
}

var oPlayer = obj_jugador;

if (instance_exists(oPlayer)) {
    var _dist = distance_to_object(oPlayer);
    if (_dist <= rango_ataque && !cargando_ataque && cooldown_descanso <= 0) {
        cargando_ataque = true;
        tiempo_carga = 0;
        parpadeo_alerta = 0;
    }
    
    if (cargando_ataque) {
        tiempo_carga++;
        parpadeo_alerta++; 
        if (_dist > rango_ataque + 25) {
            cargando_ataque = false;
            tiempo_carga = 0;
            parpadeo_alerta = 0;
        }
        
        if (tiempo_carga >= duracion_carga) {
            
            if (_dist <= rango_ataque + 25) {
                with (oPlayer) { 
                    if (!is_hit) {
                        if (!is_dead) {
                            is_hit = true;
                            image_index = 0;
                            var _dir = sign(other.x - x);
                            hsp = _dir * -7; 
                            vsp = -5;
                            player_take_damage(1, false, 1);
                            x += _dir * -10;
                            electrificado_timer = 45; 
                        }
                    }         
                }
            }
            
            for (var i = 0; i < 12; i++) {
                var _angulo_rayo = i * (360 / 12);
                var _chispa = instance_create_layer(x, y, layer, obj_efecto_chispa);
                _chispa.dir = _angulo_rayo;
                _chispa.velocidad_chispa = 3 + random(2);
            }
            
            cargando_ataque = false;
            tiempo_carga = 0;
            parpadeo_alerta = 0;
            cooldown_descanso = 120; 
        }
    }
}