var _total = array_length(niveles);

//Movimiento por teclado
if (keyboard_check_pressed(vk_right)) selected_index = (selected_index + 1) % _total;
if (keyboard_check_pressed(vk_left)) selected_index = (selected_index - 1 + _total) % _total;
if (keyboard_check_pressed(vk_down)) selected_index = (selected_index + cols) % _total;
if (keyboard_check_pressed(vk_up)) {
    selected_index = (selected_index - cols + _total) % _total;
    if (selected_index < 0) selected_index += _total;
}

// SOPORTE TACTIL : Mouses / Tocar la pantalla
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _touch_pressed = device_mouse_check_button_pressed(0, mb_left);

var _gui_w = display_get_gui_width();
var _box_w = 140;
var _box_h = 140;
var _espacio_x = 35;
var _espacio_y = 35;
var _ancho_total = (cols * _box_w) + ((cols - 1) * _espacio_x);
var _start_x = (_gui_w / 2) - (_ancho_total / 2);
var _start_y = 150;

for (var i = 0; i < _total; i++) {
    var _fila = floor(i / cols);
    var _col = i % cols;
    var _curr_x = _start_x + (_col * (_box_w + _espacio_x));
    var _curr_y = _start_y + (_fila * (_box_h + _espacio_y));
    
    if (_touch_pressed && point_in_rectangle(_mx, _my, _curr_x, _curr_y, _curr_x + _box_w, _curr_y + _box_h)) {
        selected_index = i; 
        
        var _datos = niveles[selected_index];
        if (_datos.unlocked) {
            global.nivel_activo = selected_index;
            room_goto(_datos.room_name);
        } else {
            mensaje_aviso = tr("msg_locked2");
            tiempo_aviso = 120;
        }
    }
}

var _btn_volver_x = 40;
var _btn_volver_y = 40;
var _btn_volver_w = 160;
var _btn_volver_h = 60;

if (_touch_pressed && point_in_rectangle(_mx, _my, _btn_volver_x, _btn_volver_y, _btn_volver_x + _btn_volver_w, _btn_volver_y + _btn_volver_h)) {
    room_goto(rm_selector_etapas);
}


if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z"))) {
    var _datos = niveles[selected_index];
    if (_datos.unlocked) {
        global.nivel_activo = selected_index;
        room_goto(_datos.room_name);
    } else {
        mensaje_aviso = tr("msg_locked2");
        tiempo_aviso = 120;
    }
}

if (keyboard_check_pressed(vk_escape)) room_goto(rm_selector_etapas);

if (tiempo_aviso > 0) {
    tiempo_aviso--;
    anim_y = lerp(anim_y, 1.0, 0.15);
} else {
    anim_y = lerp(anim_y, 0.0, 0.15);
}