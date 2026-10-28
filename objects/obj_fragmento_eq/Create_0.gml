// --- Sprites por código (solo una vez) ---
if (!variable_global_exists("spr_frag_materia")) {
    var _r1 = make_color_rgb(125, 112, 100);
    var _r2 = make_color_rgb(70, 62, 60);
    var _bo = make_color_rgb(40, 36, 44);

    // Materia: bloque anguloso
    var _s = surface_create(26, 26);
    surface_set_target(_s);
    draw_clear_alpha(c_black, 0);
    draw_triangle_color(13, 0, 26, 13, 13, 26, _r1, _r1, _r2, false);
    draw_triangle_color(13, 0, 0, 13, 13, 26, _r2, _r2, _r1, false);
    draw_triangle_color(13, 0, 26, 13, 13, 26, _bo, _bo, _bo, true);
    draw_triangle_color(13, 0, 0, 13, 13, 26, _bo, _bo, _bo, true);
    surface_reset_target();
    global.spr_frag_materia = sprite_create_from_surface(_s, 0, 0, 26, 26, false, false, 13, 13);
    surface_free(_s);

    // Energía: cristal luminoso
    var _e1 = make_color_rgb(110, 225, 255);
    var _e2 = make_color_rgb(160, 120, 255);
    var _s2 = surface_create(22, 22);
    surface_set_target(_s2);
    draw_clear_alpha(c_black, 0);
    draw_set_alpha(0.4);
    draw_circle_color(11, 11, 11, _e1, _e1, false);
    draw_set_alpha(1);
    draw_triangle_color(11, 1, 21, 11, 11, 21, _e1, _e1, _e2, false);
    draw_triangle_color(11, 1, 1, 11, 11, 21, _e2, _e2, _e1, false);
    draw_circle_color(11, 11, 4, c_white, c_white, false);
    surface_reset_target();
    global.spr_frag_energia = sprite_create_from_surface(_s2, 0, 0, 22, 22, false, false, 11, 11);
    surface_free(_s2);
}
sprite_index = global.spr_frag_materia;

dir_mov = 0;       // los asigna la Soberana
vel_mov = 4;
tipo = 0;          // 0 materia, 1 energía
aviso = 25;
vida = 0;