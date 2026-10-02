var oPlayer = obj_jugador;

// Control de Stun / Miel (como los demás enemigos)
if (variable_instance_exists(id, "stun_timer") && stun_timer > 0) {
    stun_timer--;
    exit; 
}

if (magnet_cooldown > 0) {
    magnet_cooldown--;
    
    // --- ESTADO DE AVISO / PREPARACIÓN ---
    // Cuando falte poco para que active el imán, encendemos la bandera de aviso
    if (magnet_cooldown <= tiempo_aviso) {
        cargando_iman = true;
    }
} else {
    cargando_iman = false;
    
    // El imán está activo succionando
    if (magnet_duration > 0) {
        magnet_duration--;
        
        if (instance_exists(oPlayer)) {
            var _dist_x = abs(x - oPlayer.x);
            var _dist_y = abs(y - oPlayer.y);
            
            if (_dist_x <= rango_vision && _dist_y < 64) {
                var _dir_h = sign(x - oPlayer.x);
                oPlayer.x += _dir_h * fuerza_atraccion; 
            }
        }
    } else {
        // Reiniciamos ciclos
        magnet_cooldown = 180;
        magnet_duration = 60;
    }
}