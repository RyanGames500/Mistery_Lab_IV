var _item = global.galeria_items[item_id];
var _centro_x = x; 
var _centro_y = y;

// 1. Dibujamos el cuadro base (spr_slot_locked) en tamaño normal (escala 1) para todos por igual
draw_sprite_ext(spr_slot_locked, 0, _centro_x, _centro_y,0.3,0.3,0,c_white,1);

// 2. Si está desbloqueado, dibujamos el icono de la transformación en su tamaño original encima
if (_item.unlocked) {
    draw_sprite(_item.sprite, 0, _centro_x, _centro_y);
} else {
    // 3. Si está bloqueado, los "???"
    draw_set_font(fnt_GUI);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_dkgray);
    draw_text(_centro_x, _centro_y, "???");
}

// 4. Número de orden abajo
draw_set_font(fnt_GUI);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(_centro_x, y + (sprite_height / 2) + 10, "# " + string(item_id + 1));