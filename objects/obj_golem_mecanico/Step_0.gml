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
    // Si está bajo efectos de miel, se mueve mucho más lento
    hsp *= 0.5; 
}

// Reducir el cooldown de ataque
if (cooldown_ataque > 0) {
    cooldown_ataque--;
}

// Aplicar gravedad constante si no está en el suelo
if (!place_meeting(x, y + 1, obj_wall)) {
    vsp += grav;
} else {
    vsp = 0;
}

// --- MÁQUINA DE ESTADOS ---
switch (estado) {
    case ESTADO_GOLEM.PATRULLA:
        hsp = dir_patrulla * vel_patrulla;
        
        image_xscale = sign(hsp);
        if (image_xscale == 0) image_xscale = 1;
        
        // Control de límites de patrulla
        if (x > xstart + limite_patrulla) dir_patrulla = -1;
        if (x < xstart - limite_patrulla) dir_patrulla = 1;
        
        // Detección de Gaby (en el mismo nivel de altura aproximado)
        if (instance_exists(oPlayer) && cooldown_ataque <= 0) {
            var _dist_x = abs(x - oPlayer.x);
            var _dist_y = abs(y - oPlayer.y);
            
            // Si Gaby está en rango horizontal y a una altura similar (suelo)
            if (_dist_x <= rango_vision && _dist_y < 48) {
                // Mira hacia donde está Gaby al detectarla
                dir_patrulla = (oPlayer.x > x) ? 1 : -1;
                image_xscale = dir_patrulla;
                
                hsp = 0;
                estado = ESTADO_GOLEM.ALERTA;
                cooldown_ataque = 40; // Tiempo de advertencia/preparación antes de correr
            }
        }
        break;
        
    case ESTADO_GOLEM.ALERTA:
        hsp = 0;
        // Animación de preparación o titileo (si la tienes)
        if (cooldown_ataque <= 0) {
            estado = ESTADO_GOLEM.CARGA;
        }
        break;
        
    case ESTADO_GOLEM.CARGA:
        // Corre con velocidad fuerte en la dirección fijada
        hsp = dir_patrulla * vel_carga;
        
        // Si choca contra una pared durante la carga, se aturde (choke)
        if (place_meeting(x + dir_patrulla, y, obj_wall)) {
            hsp = 0;
            cooldown_ataque = tiempo_choke;
            estado = ESTADO_GOLEM.CHOKE;
        }
        break;
        
    case ESTADO_GOLEM.CHOKE:
        hsp = 0;
        // Se queda quieta aturdida por chocar contra el muro
        if (cooldown_ataque <= 0) {
            cooldown_ataque = 120; // Cooldown antes de poder cargar de nuevo
            estado = ESTADO_GOLEM.REGRESO;
        }
        break;
        
    case ESTADO_GOLEM.REGRESO:
        // Vuelve caminando con calma hacia su zona de origen (xstart)
        var _dir_casa = sign(xstart - x);
        hsp = _dir_casa * vel_patrulla;
        
        image_xscale = _dir_casa;
        if (image_xscale == 0) image_xscale = 1;
        
        if (abs(x - xstart) <= 2) {
            x = xstart;
            hsp = 0;
            estado = ESTADO_GOLEM.PATRULLA;
        }
        break;
}

// --- COLISIONES HORIZONTALES ---
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) {
        x += sign(hsp);
    }
    // Si iba cargando y choca por seguridad con algo externo
    if (estado == ESTADO_GOLEM.CARGA) {
        hsp = 0;
        cooldown_ataque = tiempo_choke;
        estado = ESTADO_GOLEM.CHOKE;
    } else {
        hsp = 0;
        dir_patrulla *= -1; // Invierte patrulla si choca casualmente
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