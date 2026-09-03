var oPlayer = obj_jugador;

// --- CONTROL DEL EFECTO DE MIEL ---
if (variable_instance_exists(id, "miel_timer") && miel_timer > 0) {
    miel_timer--;
    exit; 
}

// Reducir el cooldown de ataque
if (cooldown_ataque > 0) {
    cooldown_ataque--;
}

switch (estado) {
    case ESTADO_ARP.PATRULLA:
        
        hsp = dir_patrulla * vel_patrulla;
        vsp = 0; 
        
        image_xscale = sign(hsp);
        if (image_xscale == 0) image_xscale = 1;
        
        if (x > xstart + limite_patrulla) dir_patrulla = -1;
        if (x < xstart - limite_patrulla) dir_patrulla = 1;
        
        if (instance_exists(oPlayer) && cooldown_ataque <= 0) {
            var _dist = distance_to_object(oPlayer);
            
            var _dist_x = abs(x - oPlayer.x);
            
            if (_dist <= rango_vision && _dist_x < 150 && oPlayer.y > y) {
                
                objetivo_x = oPlayer.x;
                objetivo_y = oPlayer.y;
                
                var _angulo = point_direction(x, y, objetivo_x, objetivo_y);
                var _vel_total = 7; 
                
                vel_picada_h = lengthdir_x(_vel_total, _angulo);
                vel_picada_v = lengthdir_y(_vel_total, _angulo);
                
                image_xscale = (objetivo_x > x) ? 1 : -1;
                estado = ESTADO_ARP.PICADA;
            }
        }
        break;
        
    case ESTADO_ARP.PICADA:
        
        hsp = vel_picada_h;
        vsp = vel_picada_v;
        
        if (place_meeting(x + hsp, y + vsp, obj_wall) || y >= objetivo_y + 20) {
            estado = ESTADO_ARP.REGRESO_CIELO;
        }
        break;
    case ESTADO_ARP.REGRESO_CIELO:
        
        hsp = lerp(hsp, 0, 0.1);
        vsp = -3.5; 
        if (y <= altura_patrulla_y) {
            vsp = 0;
            estado = ESTADO_ARP.REGRESO_CASA;
        }
        break;
        
    case ESTADO_ARP.REGRESO_CASA:
        
        vsp = 0;
        var _dir_casa = sign(xstart - x);
        hsp = _dir_casa * vel_patrulla;
        
        image_xscale = _dir_casa;
        if (image_xscale == 0) image_xscale = 1;
        if (abs(x - xstart) <= 2) {
            x = xstart; // Acomodo exacto
            hsp = 0;
            estado = ESTADO_ARP.ESPERA;
        }
        break;
        
    case ESTADO_ARP.ESPERA:
        hsp = 0;
        vsp = 0;
        
        cooldown_ataque = tiempo_espera_max; 
        estado = ESTADO_ARP.PATRULLA;
        break;
}

if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) {
        x += sign(hsp);
    }
    hsp = 0;
    if (estado == ESTADO_ARP.PICADA) estado = ESTADO_ARP.REGRESO_CIELO;
}
x += hsp;

if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
    if (estado == ESTADO_ARP.PICADA) estado = ESTADO_ARP.REGRESO_CIELO;
}
y += vsp;