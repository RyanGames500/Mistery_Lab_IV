if (oculta) {
    // Fantasma que avisa que va a aparecer
    if (aviso > 0) {
        draw_sprite_ext(sprite_index, image_index, x, y_base, image_xscale, image_yscale, 0,
            make_color_rgb(110, 225, 255), 0.25 + 0.25 * sin(current_time * 0.03));
    }
    exit;
}

// Parpadea antes de desaparecer
if (aviso > 0 && (aviso mod 6 < 3)) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 0.35);
} else {
    draw_self();
}