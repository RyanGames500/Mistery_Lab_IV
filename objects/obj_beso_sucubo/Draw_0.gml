var _escala_beso = 1.0 + (sin(current_time * 0.02) * 0.25);

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * _escala_beso, image_yscale * _escala_beso, 0, c_white, 1);