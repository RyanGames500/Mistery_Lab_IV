if (!other.invincible) {
    with (other) {
        if(!is_dead){
        player_take_damage(1, false, 0); 
        is_hit = true;
        image_index = 0;
        var _dir = sign(x - other.x);
        if (_dir == 0) _dir = 1;
        
        hsp = _dir * 12;
        vsp = -4;
        }
    }
}