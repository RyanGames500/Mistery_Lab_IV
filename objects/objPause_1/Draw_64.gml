var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1);

draw_set_font(fnt_small);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _cx = _gui_w / 2;
var _cy = _gui_h / 2;

draw_set_color(c_yellow);
draw_text(_cx, _cy - 80, tr("msg_pausa"));

var _color_cont = (selected == 0) ? c_white : c_gray;
var _color_salir = (selected == 1) ? c_white : c_gray;

var _y_cont = _cy - 10;
var _y_salir = _cy + 60;

draw_set_color(_color_cont);
draw_text(_cx, _y_cont + 25, tr("msg_continuar"));

draw_set_color(_color_salir);
draw_text(_cx, _y_salir + 25, tr("msg_salir_menu"));

draw_set_halign(fa_left);
draw_set_valign(fa_top);