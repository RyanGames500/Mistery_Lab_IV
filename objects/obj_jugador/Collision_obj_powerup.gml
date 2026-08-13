if (!is_transforming && !is_transformed && room != rm_galery_seccion1) {
    is_transforming = true;
    hsp = 0;
    vsp = 0;
    image_index = 0;
    sprite_index = spr_gaby_transformando; 
    var _id_a_desbloquear = other.item_id; 
    global.galeria_items[_id_a_desbloquear].unlocked = true;
    guardar_galeria();
    instance_destroy(other); 
}
else if (!is_transforming && !is_transformed && room == rm_galery_seccion1 && keyboard_check_pressed(ord("Z")) && global.galeria_items[other.item_id].unlocked == true) {
    is_transforming = true;
    hsp = 0;
    vsp = 0;
    image_index = 0;
    sprite_index = spr_gaby_transformando; 
    instance_destroy(other); 
}