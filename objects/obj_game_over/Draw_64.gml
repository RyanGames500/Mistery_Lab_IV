var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_alpha(alpha * 0.7); 
draw_rectangle_color(0, 0, _gui_w, _gui_h, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_text_transformed_color(_gui_w/2, _gui_h/3, "GAME OVER", 3, 3, 0, c_red, c_red, c_red, c_red, alpha);

var _color_restart = (selected == 0) ? c_white : c_gray;
var _color_quit    = (selected == 1) ? c_white : c_gray;

draw_text_color(_gui_w/2, _gui_h/2 + 50, "RESTART", _color_restart, _color_restart, _color_restart, _color_restart, alpha);
draw_text_color(_gui_w/2, _gui_h/2 + 100, "EXIT", _color_quit, _color_quit, _color_quit, _color_quit, alpha);