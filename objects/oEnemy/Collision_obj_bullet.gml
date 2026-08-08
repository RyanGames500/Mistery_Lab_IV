hp -= 1;
image_blend = c_red;
alarm[0] = 5;

// Activar knockback
is_knocked = true;
knockback_timer = 5;
hsp = other.image_xscale * 4;

with (other) {
    sprite_index = spr_Gaby_bullet_destroy; 
    image_index = 0;                  
    speed = 0;
    mask_index = -1;
}
screen_shake(3);