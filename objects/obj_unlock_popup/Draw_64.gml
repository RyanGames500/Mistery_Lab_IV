var _w = 400; // Ancho del recuadro
var _h = 100; // Alto del recuadro
var _x = (display_get_gui_width() - _w) / 2;
var _y = y_pos;

draw_set_alpha(alpha * 0.9);
// Fondo del popup (Negro con borde neón)
draw_set_color(c_black);
draw_roundrect(_x, _y, _x + _w, _y + _h, false);

draw_set_color(make_color_rgb(0, 255, 255)); // Neón Cyan
draw_roundrect(_x, _y, _x + _w, _y + _h, true);

// Dibujar Icono
draw_set_alpha(alpha);
if (item_sprite != -1) {
    draw_sprite_ext(item_sprite, 0, _x + 50, _y + 50, 2, 2, 0, c_white, alpha);
}

// Dibujar Texto
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_text(_x + 110, _y + 25, "NUEVO DESBLOQUEABLE!");
draw_text(_x + 110, _y + 50, item_name);

draw_set_alpha(1); // Reset