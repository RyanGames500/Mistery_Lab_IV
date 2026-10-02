if (estado == ESTADO_KITSUNE.EMBESTIDA) {
    for (var i = 1; i <= 3; i++) {
        draw_sprite_ext(sprite_index, image_index,
            x - dir_embestida * i * 14, y,
            image_xscale, image_yscale, 0, c_white, 0.25 / i);
    }
}
draw_self();