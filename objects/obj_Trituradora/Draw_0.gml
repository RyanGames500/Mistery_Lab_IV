var _suelo_y = y_destino + alto_pie;

// Zona de peligro en el suelo (se intensifica durante el aviso)
if (estado == ESTADO_TRITURADORA.PREPARACION || estado == ESTADO_TRITURADORA.CAIDA) {
    var _p = (estado == ESTADO_TRITURADORA.PREPARACION) ? (1 - timer / tiempo_aviso) : 1;
    draw_set_alpha(0.12 + 0.38 * _p);
    draw_rectangle_color(x - rango_onda, _suelo_y - 6, x + rango_onda, _suelo_y,
        c_red, c_red, make_color_rgb(255, 150, 60), make_color_rgb(255, 150, 60), false);
    draw_set_alpha(1);
}

// Onda de choque en el impacto
if (estado == ESTADO_TRITURADORA.GOLPE && onda_timer > 0) {
    draw_set_alpha(0.8 * (onda_timer / ventana_onda));
    draw_rectangle_color(x - rango_onda, _suelo_y - 14, x + rango_onda, _suelo_y,
        c_white, c_white, make_color_rgb(255, 200, 120), make_color_rgb(255, 200, 120), false);
    draw_set_alpha(1);
}

// Sprite con temblor
draw_sprite_ext(sprite_index, image_index,
    x + random_range(-temblor, temblor), y,
    image_xscale, image_yscale, image_angle, image_blend, image_alpha);