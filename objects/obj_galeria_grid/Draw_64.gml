
if (!activo) exit;

draw_set_color(c_black);
draw_set_alpha(0.9);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

var _gui_w = display_get_gui_width();
var _size = 120;
var _pad = 50;
var _cols = 6;
var _rows = ceil(array_length(items) / _cols);

var _grid_width = (_cols * _size) + ((_cols - 1) * _pad);
var _grid_height = (_rows * _size) + ((_rows - 1) * _pad);
var _frame_padding = 80; 
var _start_x = (_gui_w - _grid_width) / 2;
var _start_y = 230 + scroll_y; 


draw_sprite_stretched(spr_galeria_main, 0, _start_x - _frame_padding, _start_y - _frame_padding, _grid_width + (_frame_padding * 2), _grid_height + (_frame_padding * 2));

for (var i = 0; i < array_length(items); i++) {
    var _col = i % _cols;
    var _row = i div _cols;
    var _x = _start_x + (_col * (_size + _pad));
    var _y = _start_y + (_row * (_size + _pad));
    
    var _is_unlocked = items[i].unlocked;
    var _slot_sprite = _is_unlocked ? spr_slot_unlocked : spr_slot_locked;
    
    draw_sprite_stretched(_slot_sprite, 0, _x, _y, _size, _size);
    

    if (_is_unlocked) {
        draw_sprite_ext(items[i].sprite, 0, _x + (_size/2), _y + (_size/2), 2.5, 2.5, 0, c_white, 1);
    } else {
        draw_set_color(c_gray);
        draw_set_halign(fa_center);
        draw_text(_x + (_size/2), _y + (_size/2) - 10, "???");
    }
}

draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, 160, false); 

draw_set_font(fnt_GUI);
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text_transformed(_gui_w/2, 80, "GALERIA DE TRANSFORMACIONES", 2, 2, 0);

draw_set_halign(fa_left); 