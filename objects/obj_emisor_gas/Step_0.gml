cronometro++;

if (cronometro >= tiempo_lanzamiento) {
    cronometro = 0;
    var _nube = instance_create_layer(x, y, "Instances", obj_gas_nube);
    _nube.hsp = -4 * image_xscale; 
}