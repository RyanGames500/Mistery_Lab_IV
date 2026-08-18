
angulo_flotar += velocidad_flotar;
y = y_inicial + (sin(angulo_flotar) * amplitud_flotar);

var oPlayer = obj_jugador;

if (instance_exists(oPlayer)) {
    var _dist = distance_to_object(oPlayer);
    

    if (_dist <= rango_vision) {
        
        image_xscale = (oPlayer.x > x) ? 1 : -1;
        
        timer_ataque++;
        if (timer_ataque >= cadencia_ataque) {
            timer_ataque = 0;
            var _viento = instance_create_layer(x, y, layer, obj_rafaga_viento);
            _viento.direccion_viento = image_xscale; // Dispara hacia donde está mirando
        }
    }
}