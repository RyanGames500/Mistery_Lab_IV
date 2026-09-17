var _escala = 1.0 + (sin(current_time * 0.02) * 0.15); 
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * _escala, image_yscale * _escala, 0, c_white, 1);