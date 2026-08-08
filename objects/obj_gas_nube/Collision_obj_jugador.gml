if (!other.invincible) {
    with (other) {
        if(!is_dead){
        player_take_damage(1, false, 0);
        is_hit = true;
        image_index = 0;
        
        controls_inverted = true;
        invert_timer = 180;
        }
    }
    instance_destroy();
}