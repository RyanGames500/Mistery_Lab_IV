var _gw = display_get_gui_width();
var _w = min(360, _gw - 80);
var _h = 12;
var _x1 = (_gw - _w) / 2;
var _y1 = 30;

hp_visible = lerp(hp_visible, hp, 0.08);
var _pct   = clamp(hp / hp_max, 0, 1);
var _pct_v = clamp(hp_visible / hp_max, 0, 1);

// Color según la fase
var _color = (fase == 1) ? make_color_rgb(130, 150, 255) : make_color_rgb(255, 140, 70);

// Nombre
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(_gw / 2, _y1 - 22, "Reina del Eter");
draw_set_halign(fa_left);

// Fondo
draw_set_alpha(0.75);
draw_rectangle_color(_x1 - 3, _y1 - 3, _x1 + _w + 3, _y1 + _h + 3, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);

// Daño reciente (blanco, baja suave)
draw_rectangle_color(_x1, _y1, _x1 + _w * _pct_v, _y1 + _h, c_white, c_white, c_white, c_white, false);

// Vida actual
draw_rectangle_color(_x1, _y1, _x1 + _w * _pct, _y1 + _h, _color, _color, _color, _color, false);

// Marca del 50% (donde empieza la fase 2)
draw_line_width_color(_x1 + _w * 0.5, _y1 - 3, _x1 + _w * 0.5, _y1 + _h + 3, 2, c_white, c_white);

draw_set_color(c_white);