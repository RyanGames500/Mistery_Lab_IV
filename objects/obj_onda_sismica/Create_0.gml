// --- Sprite por código (solo una vez) ---
if (!variable_global_exists("spr_onda_sismica")) {
    var _s = surface_create(30, 34);
    surface_set_target(_s);
    draw_clear_alpha(c_black, 0);

    var _roca = make_color_rgb(110, 95, 85);
    var _luz  = make_color_rgb(255, 170, 70);

    draw_triangle_color(0, 34, 30, 34, 15, 0, _roca, _roca, _roca, false);
    draw_triangle_color(8, 34, 22, 34, 15, 12, _luz, _luz, _luz, false);

    surface_reset_target();
    global.spr_onda_sismica = sprite_create_from_surface(_s, 0, 0, 30, 34, false, false, 15, 34);
    surface_free(_s);
}
sprite_index = global.spr_onda_sismica;

hsp = 0;             // lo asigna la Emperatriz
vida = 600;
image_yscale = 0.3;  // brota