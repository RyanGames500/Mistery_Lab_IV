if (is_transformed && transform_type == 1 && vsp > 10) {
    draw_sprite_ext(sprite_index, image_index, x, y - 10, image_xscale * 1.1, image_yscale * 1.1, image_angle, c_white, 0.3);
    draw_sprite_ext(sprite_index, image_index, x, y - 20, image_xscale * 1.2, image_yscale * 1.2, image_angle, c_white, 0.15);
}

if (flash_timer > 0) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, 1);
} else {
    draw_self();
}