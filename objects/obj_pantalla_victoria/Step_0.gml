var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _touch_pressed = device_mouse_check_button_pressed(0, mb_left);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _box_w = 550;
var _box_h = 320;
var _box_x = (_gui_w / 2) - (_box_w / 2);
var _box_y = (_gui_h / 2) - (_box_h / 2);

var _accion_activada = (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z"))) || 
                       (_touch_pressed && point_in_rectangle(_mx, _my, _box_x, _box_y, _box_x + _box_w, _box_y + _box_h));

if (_accion_activada) {
    if (es_ultimo_nivel_del_mundo && fase_victoria == 0) {
        fase_victoria = 1; 
    } 
    else {
        var _m = global.mundo_activo;
        var _n = global.nivel_activo + 1;
        
        if (_n < array_length(global.mundos[_m].niveles)) {
            global.nivel_activo = _n;
            room_goto(global.mundos[_m].niveles[_n].room_name);
        } else {
            room_goto(rm_selector_etapas); 
        }
    }
}

var _btn_volver_x = 40;
var _btn_volver_y = 40;
var _btn_volver_w = 160;
var _btn_volver_h = 60;

if (_touch_pressed && point_in_rectangle(_mx, _my, _btn_volver_x, _btn_volver_y, _btn_volver_x + _btn_volver_w, _btn_volver_y + _btn_volver_h)) {
    room_goto(rm_selector_niveles);
}

if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_selector_niveles);
}