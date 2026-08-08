hp -= 1;
image_blend = c_red;
alarm[0] = 5;

// Activar knockback
is_knocked = true;
knockback_timer = 10; 
hsp = other.image_xscale * 4;
screen_shake(3);