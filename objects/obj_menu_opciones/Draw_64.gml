if (!activo) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1);

draw_set_font(fnt_small); 
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _cx = _gui_w / 2;
var _cy = _gui_h / 2;

draw_set_color(c_yellow);
draw_text(_cx, _cy - 160, tr("msg_opciones"));

var _y_base = _cy - 80;

// Usamos tr() combinando con el valor de la variable
var _txt_vol = tr("msg_volumen") + ": " + string(global.volumen);
var _txt_shd = tr("msg_shaders") + ": " + (global.shaders_activos ? "ON" : "OFF");
var _txt_lng = tr("msg_idioma") + ": " + string_upper(global.idioma_actual);
var _txt_atr = tr("msg_volver");

var _opciones = [_txt_vol, _txt_shd, _txt_lng, _txt_atr];

for (var i = 0; i < array_length(_opciones); i++) {
    var _color = (selected == i) ? c_white : c_gray;
    draw_set_color(_color);
    draw_text(_cx, _y_base + (i * 60), _opciones[i]);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);