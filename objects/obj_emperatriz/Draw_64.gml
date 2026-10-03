// No se muestra hasta que empieza la pelea ni durante las cinemáticas
if (!activada || global.cinematica) exit;

var _gw = display_get_gui_width();
var _w = min(380, _gw - 80);
var _h = 14;
var _x1 = (_gw - _w) / 2;
var _y1 = 30;

hp_visible = lerp(hp_visible, hp, 0.08);
var _pct   = clamp(hp / hp_max, 0, 1);
var _pct_v = clamp(hp_visible / hp_max, 0, 1);

// Color según la fase (ámbar -> rojo)
var _color = (fase == 1) ? make_color_rgb(235, 175, 70) : make_color_rgb(235, 80, 55);
var _borde = make_color_rgb(150, 165, 185);

// Aturdida: la barra parpadea para avisar que recibe doble daño
var _aturdida = (estado == ESTADO_EMP.ATURDIDA);
if (_aturdida && (current_time mod 300 < 150)) _color = make_color_rgb(255, 235, 140);

// Nombre
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(_gw / 2, _y1 - 22, "Emperatriz Material");
if (_aturdida) {
    draw_set_color(make_color_rgb(255, 235, 140));
    draw_text(_gw / 2, _y1 + _h + 8, "ATURDIDA  x2");
}
draw_set_halign(fa_left);

// Fondo
draw_set_alpha(0.8);
draw_rectangle_color(_x1 - 4, _y1 - 4, _x1 + _w + 4, _y1 + _h + 4, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);

// Daño reciente (blanco, baja suave)
draw_rectangle_color(_x1, _y1, _x1 + _w * _pct_v, _y1 + _h, c_white, c_white, c_white, c_white, false);

// Vida actual
draw_rectangle_color(_x1, _y1, _x1 + _w * _pct, _y1 + _h, _color, _color, _color, _color, false);

// Marco de acero
draw_rectangle_color(_x1 - 4, _y1 - 4, _x1 + _w + 4, _y1 + _h + 4, _borde, _borde, _borde, _borde, true);

// Marca del 50% (donde empieza la fase 2)
draw_line_width_color(_x1 + _w * 0.5, _y1 - 4, _x1 + _w * 0.5, _y1 + _h + 4, 2, c_white, c_white);

draw_set_color(c_white);