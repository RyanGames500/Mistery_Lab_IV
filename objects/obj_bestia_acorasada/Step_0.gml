var oPlayer = obj_jugador;

// --- CONTROL DEL EFECTO DE STUN / MIEL ---
if (variable_instance_exists(id, "stun_timer") && stun_timer > 0) {
    stun_timer--;
    hsp = 0;
    vsp = 0;
    exit; 
}

if (variable_instance_exists(id, "miel_timer") && miel_timer > 0) {
    miel_timer--;
    hsp *= 0.5; // Si le cae miel, su embestida pesada se vuelve torpe y lenta
}

// Reducir cooldowns
if (cooldown_ataque > 0) {
    cooldown_ataque--;
}

// Aplicar gravedad constante si no está en el suelo
if (!place_meeting(x, y + 1, obj_wall)) {
    vsp += grav;
} else {
    vsp = 0;
}

// --- MÁQUINA DE ESTADOS DE LA BESTIA ACORAZADA ---
switch (estado) {
    case ESTADO_BESTIA.PATRULLA:
        hsp = dir_patrulla * vel_patrulla; // (Asegúrate de declarar dir_patrulla = 1 en el Create)
        
        image_xscale = sign(hsp);
        if (image_xscale == 0) image_xscale = 1;
        
        // Control de límites de patrulla
        if (x > xstart + limite_patrulla) dir_patrulla = -1;
        if (x < xstart - limite_patrulla) dir_patrulla = 1;
        
        // --- DETECCIÓN DE GABY ---
        if (instance_exists(oPlayer) && cooldown_ataque <= 0) {
            var _dist_x = abs(x - oPlayer.x);
            var _dist_y = abs(y - oPlayer.y);
            
            // Si Gaby está en su campo visual horizontal y a la misma altura aproximada
            if (_dist_x <= rango_vision && _dist_y < 48) {
                // Mira hacia donde está Gaby
                dir_patrulla = (oPlayer.x > x) ? 1 : -1;
                image_xscale = dir_patrulla;
                
                hsp = 0;
                estado = ESTADO_BESTIA.ALERTA;
                cooldown_ataque = 40; // Breve pausa de rugido/advertencia antes de correr
            }
        }
        break;
        
    case ESTADO_BESTIA.ALERTA:
        hsp = 0;
        // Aquí puedes cambiar al sprite de "rugido" o prepararse para correr
        if (cooldown_ataque <= 0) {
            estado = ESTADO_BESTIA.EMBESTIDA;
        }
        break;
        
    case ESTADO_BESTIA.EMBESTIDA:
        // Corre con fuerza y velocidad en la dirección fijada
        hsp = dir_patrulla * vel_embestida;
        
        // Si choca contra una pared durante la embestida, se cansa/aturde (aprovechar el terreno)
        if (place_meeting(x + dir_patrulla, y, obj_wall)) {
            hsp = 0;
            cooldown_ataque = tiempo_recuperacion_carga;
            estado = ESTADO_BESTIA.REPOSO;
            
            // Temblor de pantalla por el peso de la bestia chocando
            if (script_exists(asset_get_index("screen_shake"))) {
                screen_shake(6);
            }
        }
        break;
        
    case ESTADO_BESTIA.REPOSO:
        hsp = 0;
        // Se queda cansada tras fallar la embestida contra un muro (¡ventana de castigo para Gaby!)
        if (cooldown_ataque <= 0) {
            // Regresa a su patrulla normal o se da la vuelta
            dir_patrulla *= -1;
            estado = ESTADO_BESTIA.PATRULLA;
            cooldown_ataque = 60; // Cooldown para volver a detectar
        }
        break;
}

// --- COLISIONES HORIZONTALES ---
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) {
        x += sign(hsp);
    }
    
    if (estado == ESTADO_BESTIA.EMBESTIDA) {
        hsp = 0;
        cooldown_ataque = tiempo_recuperacion_carga;
        estado = ESTADO_BESTIA.REPOSO;
        
        if (script_exists(asset_get_index("screen_shake"))) {
            screen_shake(6);
        }
    } else {
        hsp = 0;
        dir_patrulla *= -1;
    }
}
x += hsp;

// --- COLISIONES VERTICALES ---
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;

// --- COLISIÓN Y DAÑO A GABY (Estándar seguro) ---
if (place_meeting(x, y, oPlayer)) {
    with (oPlayer) {
        if (!is_dead && !is_transforming && !invincible) {
            
            player_take_damage(1, false, 1); 
            if (global.hp <= 0) {
                is_dead = true;
            }
            
            invincible = true;
            alarm[2] = 90; // Invulnerabilidad temporal
            
            // Empuje pesado por la embestida del rinoceronte
            var _dir_empuje = sign(x - other.x);
            if (_dir_empuje == 0) _dir_empuje = 1;
            hsp = _dir_empuje * 6; // Empuje fuerte
            vsp = -4;            // Vuela un poco más alto por el impacto
        }
    }
}