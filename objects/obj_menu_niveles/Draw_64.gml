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
draw_text_transformed(_gui_w / 2, 50, datos_mundo.nombre + " - " + tr("msg_select_level"), 1.4, 1.4, 0);

var cols = 5; 
var _box_w = 140;
var _box_h = 140;
var _espacio_x = 35;
var _espacio_y = 35;

var _total = array_length(niveles);
var _ancho_total = (cols * _box_w) + ((cols - 1) * _espacio_x);
var _start_x = (_gui_w / 2) - (_ancho_total / 2);
var _start_y = 150;

for (var i = 0; i < _total; i++) {
    var _fila = floor(i / cols);
    var _col = i % cols;
    var _curr_x = _start_x + (_col * (_box_w + _espacio_x));
    var _curr_y = _start_y + (_fila * (_box_h + _espacio_y));
    var _is_selected = (i == selected_index);
    var _datos = niveles[i];
    
    if (_is_selected) {
        draw_set_color(c_yellow);
        draw_rectangle(_curr_x - 5, _curr_y - 5, _curr_x + _box_w + 5, _curr_y + _box_h + 5, false);
    }
    
    draw_sprite_stretched(spr_slot_locked, 0, _curr_x, _curr_y, _box_w, _box_h);
    draw_set_valign(fa_middle);
    
    if (_datos.unlocked) {
        draw_set_color(c_white);
        draw_text_transformed(_curr_x + (_box_w / 2), _curr_y + (_box_h / 2), string(_datos.nivel_id), 1.5, 1.5, 0);
    } else {
        draw_set_color(c_gray);
        draw_text_transformed(_curr_x + (_box_w / 2), _curr_y + (_box_h / 2), "🔒", 1.5, 1.5, 0);
    }
}

draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_text(_gui_w / 2, _gui_h - 60, tr("msg_controls_level"));

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