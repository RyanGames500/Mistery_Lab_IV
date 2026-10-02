var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

barras = lerp(barras, cine_activa ? 1 : 0, 0.1);

if (barras > 0.01) {
    var _bh = _gh * 0.11 * barras;

    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _bh, false);
    draw_rectangle(0, _gh - _bh, _gw, _gh, false);

    // Título que aparece y se desvanece
    if (cine_titulo != "" && cine_activa) {
        var _a = clamp(min(cine_total - cine_timer, cine_timer) / 30, 0, 1);
        draw_set_alpha(_a);
        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(_gw / 2, _gh - _bh - 36, cine_titulo);
        draw_set_halign(fa_left);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}