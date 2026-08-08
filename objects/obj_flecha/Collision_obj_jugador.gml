if (!other.invincible) {
    with (other) {
        if(!is_dead){
        player_take_damage(1, false, 0);
        is_hit = true;
        image_index = 0;
        hsp = sign(other.hsp) * 10;
        vsp = -3;
        
        //EFECTO DE VENENO
        is_poisoned = true;
        poison_timer = 180;
        }
    }
}
instance_destroy();