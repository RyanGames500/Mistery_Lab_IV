angulo_flotar += velocidad_flotar;
y = y_inicial + (sin(angulo_flotar) * amplitud_flotar);
escala_visual = 1 + (cos(angulo_flotar * 2) * 0.1);
if (cooldown_descanso > 0) {
    cooldown_descanso--;
}

var oPlayer = obj_jugador;

// --- CONTROL DEL EFECTO DE STUN (Beso de Sucubus) ---
if (variable_instance_exists(id, "stun_timer") && stun_timer > 0) {
    stun_timer--;
    hsp = 0;
    vsp = 0;
    exit; 
}

// --- CONTROL DEL EFECTO DE MIEL ---
if (variable_instance_exists(id, "miel_timer") && miel_timer > 0) {
    miel_timer--;
    exit; 
}

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
                        if (!is_dead && !is_transforming) {
                            
                            // CASO A: Si ya está transformado en la medusa (Tipo 10)
                            if (is_transformed && transform_type == 10) {
                                player_take_damage(1, false, 1);
                                is_hit = true;
                                image_index = 0;
                                image_speed = 1;
                                
                                // Activamos la bandera de golpe especial para el tipo 10 (similar al avión o ninfa)
                                golpe_medusa_especial = true; 
                                
                                var _dir = sign(other.x - x);
                                hsp = _dir * -7; 
                                vsp = -5;
                                x += _dir * -10;
                                electrificado_timer = 45; 
                            } 
                            // CASO B: Si se transforma por primera vez en medusa
                            else {
                                global.hp -= 1;
                                if (global.hp <= 0) { is_dead = true; }
                                
                                invincible = true;
                                alarm[2] = 90;
                                
                                golpe_medusa_especial = false;
                                
                                is_transforming = true;
                                is_transformed = false;
                                hsp = 0;
                                vsp = 0;
                                image_index = 0;
                                image_speed = 1; 
                                
                                transform_type = 10;
                                sprite_index = spr_gaby_medusa_transformando; // Cambia por tu sprite de transformación
                                
                                electrificado_timer = 45;
                                
                                // Desbloqueo seguro en galería
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