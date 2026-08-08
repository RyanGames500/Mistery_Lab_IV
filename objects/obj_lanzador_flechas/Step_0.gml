cronometro++;

if (cronometro >= tiempo_disparo) {
    cronometro = 0;
    
    // Crea la flecha apuntando hacia la dirección configurada
    var _flecha = instance_create_layer(x, y, "Instances", obj_flecha);
    _flecha.hsp = 8 * direccion_disparo;
    _flecha.image_xscale = direccion_disparo; // Para que el sprite de la flecha apunte bien
}