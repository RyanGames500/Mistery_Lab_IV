var _color_dibujo = c_white;
if (cargando_ataque) {
    if ((parpadeo_alerta div 4) mod 2 == 0) {
        _color_dibujo = c_aqua;
    } else {
        _color_dibujo = c_white;
    }
}
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * escala_visual, image_yscale * escala_visual, image_angle, _color_dibujo, image_alpha);