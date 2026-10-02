var oPlayer = obj_jugador;

// --- CONTROL DEL EFECTO DE STUN / MIEL ---
if (variable_instance_exists(id, "stun_timer") && stun_timer > 0) {
    stun_timer--;
    exit; 
}

// Reducir temporizadores generales del ciclo
if (cooldown_ciclo > 0) {
    cooldown_ciclo--;
}

// --- MÁQUINA DE ESTADOS DE LA TRITURADORA ---
switch (estado) {
    case ESTADO_TRITURADORA.ESPERA:
        // Permanece fija, esperando a que Gaby se acerque o a que termine el tiempo de pausa
        // Opcional: Podría activarse si Gaby está en un rango de proximidad horizontal
        if (cooldown_ciclo <= 0) {
            // Cambia a estado de advertencia/preparación antes de golpear
            cooldown_ciclo = 30; // Tiempo de parpadeo o animación de carga
            estado = ESTADO_TRITURADORA.PREPARACION;
        }
        break;
        
    case ESTADO_TRITURADORA.PREPARACION:
        // Aquí puedes hacer que parpadee o se tense antes del martillazo
        if (cooldown_ciclo <= 0) {
            estado = ESTADO_TRITURADORA.GOLPE;
            cooldown_ciclo = tiempo_golpe;
            
            // Movimiento rápido hacia abajo (slam)
            y = y_destino;
            
            // --- EFECTO DE IMPACTO EN EL SUELO Y ONDA DE CHOQUE ---
            if (script_exists(asset_get_index("screen_shake"))) {
                screen_shake(fuerza_impacto);
            }
            
            // --- ONDA EXPANSIVA: DESESTABILIZAR A GABY SI ESTÁ CERCA Y EN EL SUELO ---
            if (instance_exists(oPlayer)) {
                var _dist_x = abs(x - oPlayer.x);
                var _rango_onda = 160; // Rango horizontal que afecta la onda de choque
                
                if (_dist_x <= _rango_onda) {
                    with (oPlayer) {
                        // Solo si Gaby está en el suelo y no está en medio de otra animación pesada
                        if (place_meeting(x, y + 1, obj_wall) && !is_dead && !is_transforming) {
                            
                            // Efecto de tambaleo / mini salto por la onda expansiva del suelo
                            vsp = -4; // La empuja un poquito hacia arriba por el retumbo del piso
                            
                            // Opcional: un leve empuje horizontal dependiendo de dónde esté
                            var _dir_onda = sign(x - other.x);
                            if (_dir_onda == 0) _dir_onda = 1;
                            hsp = _dir_onda * 3;
                        }
                    }
                }
            }
        }
        break;
        
    case ESTADO_TRITURADORA.GOLPE:
        // Está abajo haciendo daño en área (zona de impacto del martillo)
        
        // --- COLISIÓN Y DAÑO A GABY ---
        if (place_meeting(x, y, oPlayer)) {
            with (oPlayer) {
                // Solo le hace daño si NO está muerta, NO se está transformando y NO es invulnerable
                if (!is_dead && !is_transforming && !invincible) {
                    
                    // Restar vida estándar
                    player_take_damage(1, false, 1); 
                    if (global.hp <= 0) {
                        is_dead = true;
                    }
                    
                    // Activar invulnerabilidad temporal y alarma de parpadeo
                    invincible = true;
                    alarm[2] = 90; // Tiempo de invulnerabilidad
                    
                    // Empuje físico por el impacto del martillo pesado
                    var _dir_empuje = sign(x - other.x);
                    if (_dir_empuje == 0) _dir_empuje = 1;
                    hsp = _dir_empuje * 4;
                    vsp = -3; // Pequeño salto hacia arriba por el golpe en suelo
                }
            }
        }
        
        if (cooldown_ciclo <= 0) {
            estado = ESTADO_TRITURADORA.RECUPERACION;
            cooldown_ciclo = 60; // Tiempo que tarda en volver arriba
        }
        break;
        
    case ESTADO_TRITURADORA.RECUPERACION:
        // Regresa suavemente a su posición original arriba
        y = lerp(y, y_original, 0.2); // Sube de golpe o de forma fluida
        
        if (cooldown_ciclo <= 0 || abs(y - y_original) <= 1) {
            y = y_original;
            estado = ESTADO_TRITURADORA.ESPERA;
            cooldown_ciclo = tiempo_espera; // Reinicia el ciclo de espera
        }
        break;
}