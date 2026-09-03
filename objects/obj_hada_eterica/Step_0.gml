angulo_flotar += velocidad_flotar;
var _offset_v = sin(angulo_flotar) * amplitud_flotar;
var oPlayer = obj_jugador;

// --- CONTROL DEL EFECTO DE MIEL ---
if (variable_instance_exists(id, "miel_timer") && miel_timer > 0) {
    miel_timer--;
    exit; 
}

if (instance_exists(oPlayer)) {
    var _dist = distance_to_object(oPlayer);
    
    if (_dist <= rango_vision) {
        
        var _diferencia_x = oPlayer.x - x;
        if (abs(_diferencia_x) > 10) {
            image_xscale = sign(_diferencia_x);
        }

        if (_dist > distancia_ideal + 20) {
            hsp = sign(_diferencia_x) * vel;
        } 
        else if (_dist < distancia_ideal - 20) {
            hsp = -sign(_diferencia_x) * vel;
        } 
        else {
            hsp = lerp(hsp, 0, 0.1);
        }
   
        timer_disparo++;
        if (timer_disparo >= cadencia_disparo) {
            timer_disparo = 0;
            
            var _orbe = instance_create_layer(x, y, layer, obj_orbe_energia);
            _orbe.direc = image_xscale;
        }
    } else {
        hsp = lerp(hsp, 0, 0.1);
    }
} else {
    hsp = lerp(hsp, 0, 0.1);
}

x += hsp;
y += _offset_v;