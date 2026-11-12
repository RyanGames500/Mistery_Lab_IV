var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

if (flash > 0 && flash_max > 0) {
    var _a = (flash / flash_len) * flash_max;
    draw_set_alpha(_a);
    draw_set_color(c_white);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(_a * 0.5);
    draw_set_color(c1);
    draw_rectangle(0, 0, _gw, _gh, false);
}

if (popup_t > 0 && nombre != "") {
    var _cam = view_camera[0];
    var _sx = _gw / camera_get_view_width(_cam);
    var _gx = (x - camera_get_view_x(_cam)) * _sx;
    var _gy = (y - 100 - camera_get_view_y(_cam)) * _sx;

    var _t = 80 - popup_t;
    var _esc = FX_TEXTO_ESCALA * (1 + 0.7 * exp(-_t / 5));
    var _al = min(1, popup_t / 20);
    var _txt = "¡" + nombre + "!";

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(_al);
    draw_set_color(make_color_rgb(27, 18, 38));
    for (var dx = -3; dx <= 3; dx += 3) {
        for (var dy = -3; dy <= 3; dy += 3) {
            if (dx != 0 || dy != 0) draw_text_transformed(_gx + dx, _gy + dy, _txt, _esc, _esc, 0);
        }
    }
    draw_text_transformed_color(_gx, _gy, _txt, _esc, _esc, 0, c_white, c_white, c1, c1, _al);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_alpha(1);
draw_set_color(c_white);