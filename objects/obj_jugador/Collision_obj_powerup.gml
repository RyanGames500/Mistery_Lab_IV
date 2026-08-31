if (!is_transforming && !is_transformed && room != rm_galery_seccion1) {
    is_transforming = true;
    hsp = 0;
    vsp = 0;
    image_index = 0;
    
    // 1. Asignamos primero el transform_type
    transform_type = other.item_id; 
    
    // 2. Elegimos el sprite de transformación correcto
    if (transform_type == 3 || transform_type == 1) { // Si es Globo (o ID 1 de galería)
        sprite_index = spr_gaby_globo_transformando;
    } else {
        sprite_index = spr_gaby_transformando;
    }
    
    global.galeria_items[other.item_id].unlocked = true;
    guardar_galeria();
    instance_destroy(other); 
}
else if (!is_transforming && !is_transformed && room == rm_galery_seccion1 && keyboard_check_pressed(ord("Z")) && global.galeria_items[other.item_id].unlocked == true) {
    is_transforming = true;
    hsp = 0;
    vsp = 0;
    image_index = 0;
    
    transform_type = other.item_id; 
    
    if (transform_type == 3 || transform_type == 1) {
        sprite_index = spr_gaby_globo_transformando;
    } else {
        sprite_index = spr_gaby_transformando;
    }
    
    instance_destroy(other); 
}