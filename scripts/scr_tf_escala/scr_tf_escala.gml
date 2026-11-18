// Tamaño base de cada forma (1 = tamaño original del sprite)
function tf_escala(_tipo) {
    switch (_tipo) {
        case 3:  return 0.55;   // globo
        case 4:  return 0.7;    // nube
        case 5:  return 0.8;    // abeja
        case 6:  return 0.75;   // tobogán
        case 9:  return 0.8;    // avión
        case 10: return 0.6;    // medusa
        case 11:
        case 12: return variable_instance_exists(id, "escala_tf") ? escala_tf : 0.6;   // hada / arpia
        default: return 1;      // Gaby, bola, cristal, súcubo, ninfa
    }
}