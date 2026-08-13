if (!activo) exit;

if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
    selected_index = (selected_index + 1) % array_length(items);
}
if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
    selected_index = (selected_index - 1 + array_length(items)) % array_length(items);
}

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z"))) {
    var _item = items[selected_index];
    var _is_bought = variable_global_get(_item.bought_var);
    
    if (!_is_bought && global.coins >= _item.price) {
        global.coins -= _item.price;
        variable_global_set(_item.bought_var, true);
        //sonido
    }
}

if (keyboard_check_pressed(vk_escape)) {
    activo = false;
    instance_activate_all();
}