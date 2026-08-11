cronometro++;

if (cronometro >= tiempo_disparo && distance_to_object(obj_jugador) <= rango) 
{
    cronometro = 0;
    
    var _flecha = instance_create_layer(x, y, "Instances", obj_flecha);
    _flecha.hsp = 8 * direccion_disparo;
    _flecha.image_xscale = direccion_disparo; 
}