if (!activo) exit;

draw_set_color(c_black);
draw_set_alpha(0.9);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

var _cx = display_get_gui_width() / 2;
var _cy = display_get_gui_height() / 2;

draw_set_font(fnt_GUI);
draw_set_halign(fa_center);
draw_set_color(c_aqua);
draw_text_transformed(_cx, 80, "GALERIA DE TRANSFORMACIONES", 2, 2, 0);

var _frame_w = 500;
var _frame_h = 400;
draw_sprite_stretched(spr_galeria_main, 0, _cx - (_frame_w / 2), _cy - (_frame_h / 2) + 50, _frame_w, _frame_h);

var _item = items[selected_index];
if (_item.unlocked) {
    draw_sprite_ext(_item.sprite, 0, _cx, _cy + 50, 4, 4, 0, c_white, 1);
} else {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_cx, _cy + 50, "???");
}

draw_set_font(fnt_GUI); 
draw_set_halign(fa_center);
draw_set_color(c_yellow); 
if (slideshow_mode) {
    draw_text(_cx, display_get_gui_height() - 80, "MODO PRESENTACION - Presiona cualquier tecla para salir");
} else {
    draw_text(_cx, display_get_gui_height() - 80, "Flechas: Navegar | S: Presentacion | Esc: Salir");
}