if (active && !other.is_hit) {
if(!is_dead){
    other.is_hit = true;
    other.image_index = 0;

    var _dir = sign(other.x - x);
    other.hsp = _dir * 7; 
    other.vsp = -5;
    
    with (other) {
        player_take_damage(1, false, 1);
        x += _dir * 10; 
    }
}
}