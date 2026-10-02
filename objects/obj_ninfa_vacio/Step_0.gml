var oPlayer = obj_jugador;

if (variable_instance_exists(id, "stun_timer") && stun_timer > 0) {
    stun_timer--;
    hsp = 0;
    vsp = 0;
    exit; 
}

if (variable_instance_exists(id, "miel_timer") && miel_timer > 0) {
    miel_timer--;
    exit; 
}

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
            
            // IMPACTO INMEDIATO EN EL AIRE AL TOCAR AL JUGADOR
            if (place_meeting(x, y, oPlayer) && (!variable_instance_exists(id, "impacto_iniciado") || !impacto_iniciado)) {
                impacto_iniciado = true;
                oPlayer.depth = depth - 10; 

                with (oPlayer) {
                    if (!is_dead && !is_transforming) {
                        
                        // CASO A: Si ya es condón, usa tu función de daño oficial (maneja invencibilidad y vida)
                        if (is_transformed && transform_type == 8) {
                            player_take_damage(1, false, "normal");
                            
                            is_hit = true;
                            image_index = 0;
                            image_speed = 1;
                            sprite_index = spr_gaby_condon_arrugado; 
                            golpe_ninfa_especial = true;
                            
                            other.duracion_anim_player = sprite_get_number(spr_gaby_condon_arrugado);
                        } 
                        // CASO B: Si se va a transformar por primera vez, resta vida directo y arranca la TF
                        else {
                            global.hp -= 1;
                            if (global.hp <= 0) { is_dead = true; }
                            
                            is_transforming = true;
                            is_transformed = false;
                            hsp = 0;
                            vsp = 0;
                            image_index = 0;
                            image_speed = 1; 
                            
                            transform_type = 8;
                            sprite_index = spr_gaby_ninfa_transformando; 
                            
                            other.duracion_anim_player = sprite_get_number(spr_gaby_ninfa_transformando);
                            
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
            
            // Al chocar con el suelo, sacude y espera a que termine la animación del player
            if (place_meeting(x, y + 1, obj_wall)) {
                screen_shake(5);
                vsp = 0;
                
                if (variable_instance_exists(id, "duracion_anim_player")) {
                    timer_espera_tf = duracion_anim_player;
                } else {
                    timer_espera_tf = 17; 
                }
                
                estado = ESTADO_NINFA.ESPERA_TRANSFORMACION;
            }
            break;
            
        case ESTADO_NINFA.ESPERA_TRANSFORMACION:
            hsp = 0;
            vsp = 0;
            timer_espera_tf--;
            
            if (timer_espera_tf <= 0) {
                oPlayer.depth = 0; 
                estado = ESTADO_NINFA.SUBIR_TRAS_GOLPE;
            }
            break;
            
        case ESTADO_NINFA.SUBIR_TRAS_GOLPE:
            vsp = -4;
            y += vsp;
            
            if (y <= y_inicial) {
                vsp = 0;
                timer_ataque = 60; 
                y_inicial = y;
                impacto_iniciado = false; // ¡Resetea la bandera para permitir futuros golpes!
                estado = ESTADO_NINFA.INACTIVA;
            }
            break;
    }
}