// --- Sprite del fragmento por código (solo una vez) ---
if (!variable_global_exists("spr_fragmento")) {
    var _w = 20;
    var _h = 10;
    var _s = surface_create(_w, _h);

    surface_set_target(_s);
    draw_clear_alpha(c_black, 0);

    var _luz  = make_color_rgb(255, 245, 190);
    var _oro  = make_color_rgb(240, 200, 90);

    // Astilla tipo cristal apuntando a la derecha
    draw_triangle_color(0, 5, 14, 0, 14, 10, _oro, _oro, _oro, false);
    draw_triangle_color(12, 0, 20, 5, 12, 10, _luz, _luz, _luz, false);

    surface_reset_target();

    global.spr_fragmento = sprite_create_from_surface(_s, 0, 0, _w, _h, false, false, _w / 2, _h / 2);
    surface_free(_s);
}

sprite_index = global.spr_fragmento;