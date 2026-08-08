
if (!is_transforming && !is_transformed) {
    is_transforming = true;
    hsp = 0;
    image_index = 0;
    sprite_index = spr_gaby_transformando; 
    instance_destroy(other); 
}