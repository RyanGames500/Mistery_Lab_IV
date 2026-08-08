function player_take_damage(_damage, _instant_kill, _type) {
    
    // ESTO TE DIRÁ LA VERDAD EN LA VENTANA DE "OUTPUT"
    show_debug_message("¿Es invencible al entrar?: " + string(invincible));
    
    if (invincible || is_dead) {
        show_debug_message("¡Entró al IF de invencibilidad, saliendo!");
        exit; 
    }
    
    if (_instant_kill) {
        global.hp = 0;
        is_dead = true;
        is_hit = false;
        death_type = _type; 
    } else {
        global.hp -= _damage;
        is_hit = true;
        image_index = 0;
        screen_shake(4);
        
        invincible = true;
        alarm[2] = 90;
        show_debug_message("¡INVENCIBILIDAD ACTIVADA A TRUE!");
    }
    
    if (global.hp <= 0) {
        is_dead = true;
    }
}

function desbloquear_item(_id_a_desbloquear) {
    for (var i = 0; i < array_length(global.galeria_items); i++) {
        if (global.galeria_items[i].item_id == _id_a_desbloquear) {
            
            if (global.galeria_items[i].unlocked == false) {
                global.galeria_items[i].unlocked = true;
                
                var _popup = instance_create_layer(0, 0, "Instances", obj_unlock_popup);
                _popup.item_sprite = global.galeria_items[i].sprite;
                _popup.item_name = global.galeria_items[i].name;
            }
            
            break;
        }
    }
}

function guardar_galeria() {
    ini_open("save.ini");
    for (var i = 0; i < array_length(global.galeria_items); i++) {
        ini_write_real("Galeria", string(global.galeria_items[i].item_id), global.galeria_items[i].unlocked);
    }
    ini_close();
}

function cargar_galeria() {
    ini_open("save.ini");
    for (var i = 0; i < array_length(global.galeria_items); i++) {
        var _id_actual = global.galeria_items[i].item_id;
        
        global.galeria_items[i].unlocked = ini_read_real("Galeria", string(_id_actual), 0);
    }
    ini_close();
}