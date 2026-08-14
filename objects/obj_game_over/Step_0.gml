alpha = min(alpha + 0.02, 1);

if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down)) {
    selected = !selected;
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _touch_pressed = device_mouse_check_button_pressed(0, mb_left);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _btn_w = 400;
var _btn_h = 40;
var _x1 = (_gui_w / 2) - (_btn_w / 2);

var _y_restart = _gui_h/2 + 50;
var _y_quit = _gui_h/2 + 100;

if (_touch_pressed) {
    if (point_in_rectangle(_mx, _my, _x1, _y_restart, _x1 + _btn_w, _y_restart + _btn_h)) {
        selected = 0;
        game_restart();
    }
    else if (point_in_rectangle(_mx, _my, _x1, _y_quit, _x1 + _btn_w, _y_quit + _btn_h)) {
        selected = 1;
        game_end();
    }
}

if (keyboard_check_pressed(vk_enter)) {
    if (selected == 0) game_restart(); 
    else game_end();               
}