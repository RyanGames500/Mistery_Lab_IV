var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_alpha(1);
draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1);

draw_set_font(fnt_GUI);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_aqua);
draw_text_transformed(_gui_w / 2, 80, tr("msg_select_stage"), 1.5, 1.5, 0);

var _box_w = 220;
var _box_h = 160;
var _espacio = 40;

var _ancho_total = (total_mundos * _box_w) + ((total_mundos - 1) * _espacio);
var _start_x = (_gui_w / 2) - (_ancho_total / 2);
var _start_y = (_gui_h / 2) - 60;

for (var i = 0; i < total_mundos; i++) {
    var _curr_x = _start_x + (i * (_box_w + _espacio));
    var _curr_y = _start_y;
    var _is_selected = (i == selected_mundo);
    
    if (_is_selected) {
        draw_set_color(c_yellow);
        draw_rectangle(_curr_x - 4, _curr_y - 4, _curr_x + _box_w + 4, _curr_y + _box_h + 4, false);
    }
    
    draw_sprite_stretched(spr_slot_locked, 0, _curr_x, _curr_y, _box_w, _box_h);
    draw_set_font(fnt_GUI);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _mundo_actual = global.mundos[i];
    if (_mundo_actual.unlocked) {
        draw_set_color(c_white);
        draw_text(_curr_x + (_box_w / 2), _curr_y + (_box_h / 2), _mundo_actual.nombre);
    } else {
        draw_set_color(c_gray);
        draw_text(_curr_x + (_box_w / 2), _curr_y + (_box_h / 2), tr("msg_locked"));
    }
}

draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_text(_gui_w / 2, _gui_h - 80, tr("msg_controls_main"));

if (anim_y > 0.01) {
    draw_set_alpha(0.9 * anim_y);
    draw_rectangle(_gui_w - 450, _gui_h - 90, _gui_w - 30, _gui_h - 30, false);
    draw_set_alpha(1.0 * anim_y);
    draw_set_color(c_orange);
    draw_rectangle(_gui_w - 450, _gui_h - 90, _gui_w - 30, _gui_h - 30, true);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_gui_w - 240, _gui_h - 60, mensaje_aviso);
    draw_set_alpha(1);
}

// DIBUJAR BOTON TACTIL DE VOLVER
var _btn_volver_x = 40;
var _btn_volver_y = 40;
var _btn_volver_w = 160;
var _btn_volver_h = 60;

draw_set_color(c_dkgray);
draw_rectangle(_btn_volver_x, _btn_volver_y, _btn_volver_x + _btn_volver_w, _btn_volver_y + _btn_volver_h, false);
draw_set_color(c_white);
draw_rectangle(_btn_volver_x, _btn_volver_y, _btn_volver_x + _btn_volver_w, _btn_volver_y + _btn_volver_h, true);

draw_set_font(fnt_GUI);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_btn_volver_x + (_btn_volver_w / 2), _btn_volver_y + (_btn_volver_h / 2), tr("msg_atras"));
draw_set_valign(fa_top); // Reset por seguridad