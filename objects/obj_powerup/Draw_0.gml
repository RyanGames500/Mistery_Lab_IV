
if(room == rm_galery_seccion1)
{
var _datos = global.galeria_items[item_id];

if (_datos.unlocked) 
{
    draw_sprite(sprite_index, 0, x, y);
} else {
    draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, c_black, 0.5); 
    draw_text(x, y - 30, "LOCKED");
}
}
else 
{
	draw_self();
}