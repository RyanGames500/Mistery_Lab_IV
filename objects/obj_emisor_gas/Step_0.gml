cronometro++;

if (cronometro >= tiempo_lanzamiento && distance_to_object(obj_jugador) <= rango) {
    cronometro = 0;
    var _nube = instance_create_layer(x, y, "Instances", obj_gas_nube);
    _nube.hsp = -4 * image_xscale; 
}