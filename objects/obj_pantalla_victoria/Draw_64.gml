var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1);

var _box_w = 550;
var _box_h = 320;
var _box_x = (_gui_w / 2) - (_box_w / 2);
var _box_y = (_gui_h / 2) - (_box_h / 2);

draw_set_color(c_dkgray);
draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false);

draw_set_color(c_yellow);
draw_rectangle(_box_x - 4, _box_y - 4, _box_x + _box_w + 4, _box_y + _box_h + 4, true);

draw_set_font(fnt_GUI);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);

if (fase_victoria == 0) {
    draw_text(_gui_w / 2, _box_y + 30, tr("msg_nivel_completado"));
    
    draw_set_color(c_aqua);
    draw_text(_gui_w / 2, _box_y + 90, tr("msg_buen_trabajo"));
    
    draw_set_color(c_white);
    draw_text(_gui_w / 2, _box_y + 160, tr("msg_sig_continuar"));
    draw_text(_gui_w / 2, _box_y + 210, tr("msg_volver_niveles"));
} 
else {
    draw_set_color(c_yellow);
    draw_text(_gui_w / 2, _box_y + 30, tr("msg_etapa_superada"));
    
    draw_set_color(c_aqua);
    draw_text(_gui_w / 2, _box_y + 85, tr("msg_felicidades_etapa"));
    
    draw_set_color(c_white);
    draw_text(_gui_w / 2, _box_y + 175, tr("msg_ir_selector_mundos"));
}


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

// Reset por seguridad
draw_set_valign(fa_top);
draw_set_halign(fa_left);