if (estado == "ATACANDO" && !other.invincible) {
    var _tronco_dir = image_xscale;
    if (_tronco_dir == 0) _tronco_dir = 1;
    
    with (other) {
        if (!is_dead) {
            //player_take_damage(1, false, 0);
            is_hit = true;
            image_index = 0;
            hsp = _tronco_dir * 18;
            vsp = -3;
            x += _tronco_dir * 16; 
        }
    }
}