var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _touch = device_mouse_check_button_pressed(0, mb_left);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _btn_w = 400;
var _btn_h = 50;
var _x1 = (_gui_w / 2) - (_btn_w / 2);
var _y_cont = (_gui_h / 2) - 10;
var _y_salir = (_gui_h / 2) + 60;

if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_up)) {
    selected = !selected;
}

if (point_in_rectangle(_mx, _my, _x1, _y_cont, _x1 + _btn_w, _y_cont + _btn_h)) {
    selected = 0;
    if (_touch) {
        global.pausado = false;
        audio_resume_all();
        instance_destroy();
    }
}
else if (point_in_rectangle(_mx, _my, _x1, _y_salir, _x1 + _btn_w, _y_salir + _btn_h)) {
    selected = 1;
    if (_touch) {
        global.pausado = false;
        audio_resume_all();
        room_goto(rm_main);
    }
}

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z"))) {
    if (selected == 0) {
        global.pausado = false;
        audio_resume_all();
        instance_destroy();
    } else {
        global.pausado = false;
        audio_resume_all();
        room_goto(rm_main);
    }
}