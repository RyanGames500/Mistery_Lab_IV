with (other) {
    if (estado == "MAREADA") {
        hp -= 10;
        screen_shake(1);
        
        if (hp > 0) {
            estado_anterior = estado; 
            
            estado = "HIT";
            
            image_index = 0; 
        }
    }
}