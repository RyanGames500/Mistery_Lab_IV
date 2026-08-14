// Movimiento por teclado
if (keyboard_check_pressed(vk_right)) selected_mundo = (selected_mundo + 1) % total_mundos;
if (keyboard_check_pressed(vk_left)) selected_mundo = (selected_mundo - 1 + total_mundos) % total_mundos;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _touch_pressed = device_mouse_check_button_pressed(0, mb_left);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _box_w = 220;
var _box_h = 160;
var _espacio = 40;
var _ancho_total = (total_mundos * _box_w) + ((total_mundos - 1) * _espacio);
var _start_x = (_gui_w / 2) - (_ancho_total / 2);
var _start_y = (_gui_h / 2) - 60;

for (var i = 0; i < total_mundos; i++) {
    var _curr_x = _start_x + (i * (_box_w + _espacio));
    var _curr_y = _start_y;
    
    // Si tocan un mundo con el dedo:
    if (_touch_pressed && point_in_rectangle(_mx, _my, _curr_x, _curr_y, _curr_x + _box_w, _curr_y + _box_h)) {
        selected_mundo = i;
        if (global.mundos[selected_mundo].unlocked == true) {
            global.mundo_activo = selected_mundo;
            room_goto(rm_selector_niveles);
        } else {
            mensaje_aviso = tr("msg_locked");
            tiempo_aviso = 120;
        }
    }
}

var _btn_volver_x = 40;
var _btn_volver_y = 40;
var _btn_volver_w = 160;
var _btn_volver_h = 60;

if (_touch_pressed && point_in_rectangle(_mx, _my, _btn_volver_x, _btn_volver_y, _btn_volver_x + _btn_volver_w, _btn_volver_y + _btn_volver_h)) {
    room_goto(rm_main);
}

// Controles normales de teclado
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z"))) {
    if (global.mundos[selected_mundo].unlocked == true) {
        global.mundo_activo = selected_mundo;
        room_goto(rm_selector_niveles);
    } else {
        mensaje_aviso = tr("msg_locked");
        tiempo_aviso = 120;
    }
}

if (keyboard_check_pressed(vk_escape)) room_goto(rm_main);

if (tiempo_aviso > 0) {
    tiempo_aviso--;
    anim_y = lerp(anim_y, 1.0, 0.15);
} else {
    anim_y = lerp(anim_y, 0.0, 0.15);
}