// --- Sprite de la onda por código (solo una vez) ---
if (!variable_global_exists("spr_onda")) {
    var _w = 28;
    var _h = 24;
    var _s = surface_create(_w, _h);

    surface_set_target(_s);
    draw_clear_alpha(c_black, 0);

    var _fuerte = make_color_rgb(200, 90, 255);
    var _claro  = make_color_rgb(240, 200, 255);

    // Pico de energía dimensional
    draw_triangle_color(0, 24, 28, 24, 14, 0, _fuerte, _fuerte, _fuerte, false);
    draw_triangle_color(7, 24, 21, 24, 14, 8, _claro, _claro, _claro, false);

    surface_reset_target();

    global.spr_onda = sprite_create_from_surface(_s, 0, 0, _w, _h, false, false, _w / 2, _h);
    surface_free(_s);
}

sprite_index = global.spr_onda;
hsp = 0;          // lo asigna el Avatar al crearla
vida = 60;        // frames de vida