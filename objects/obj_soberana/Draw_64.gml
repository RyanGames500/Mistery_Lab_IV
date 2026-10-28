if (!activada || global.cinematica) exit;

var _gw = display_get_gui_width();
var _w = min(380, _gw - 80);
var _h = 14;
var _x1 = (_gw - _w) / 2;
var _y1 = 30;

hp_visible = lerp(hp_visible, hp, 0.08);
var _pct   = clamp(hp / hp_max, 0, 1);
var _pct_v = clamp(hp_visible / hp_max, 0, 1);

var _c_en  = make_color_rgb(110, 225, 255);
var _c_mat = make_color_rgb(255, 190, 90);
if (fase == 2) { _c_en = make_color_rgb(190, 130, 255); _c_mat = make_color_rgb(255, 110, 70); }
var _borde = make_color_rgb(160, 150, 200);

draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(_gw / 2, _y1 - 22, "Soberana del Equilibrio");
draw_set_halign(fa_left);

draw_set_alpha(0.8);
draw_rectangle_color(_x1 - 4, _y1 - 4, _x1 + _w + 4, _y1 + _h + 4, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);

draw_rectangle_color(_x1, _y1, _x1 + _w * _pct_v, _y1 + _h, c_white, c_white, c_white, c_white, false);
draw_rectangle_color(_x1, _y1, _x1 + _w * _pct, _y1 + _h, _c_en, _c_mat, _c_mat, _c_en, false);

draw_rectangle_color(_x1 - 4, _y1 - 4, _x1 + _w + 4, _y1 + _h + 4, _borde, _borde, _borde, _borde, true);
draw_line_width_color(_x1 + _w * 0.5, _y1 - 4, _x1 + _w * 0.5, _y1 + _h + 4, 2, c_white, c_white);

draw_set_color(c_white);