if (other.estado == "ATAQUE") {
    effect_create_above(ef_spark, x, y, 0, c_aqua);
    if (x < other.x) {
        direction = 135; 
    } else {
        direction = 45;
    }
    image_angle = direction; 
    speed = 8; 
} else {

     with (other) {
         if (estado != "HIT" && estado == "MAREADA") {
             hp -= 10;
             
             estado_anterior = estado; 
             estado = "HIT";
             
             audio_stop_sound(snd_mareo);
         }
     }
     instance_destroy();
}