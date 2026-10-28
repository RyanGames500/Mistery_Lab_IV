// --- Sprite por código (solo una vez) ---
if (!variable_global_exists("spr_astral")) {
    var _s = surface_create(20, 20);
    surface_set_target(_s);
    draw_clear_alpha(c_black, 0);

    var _halo = make_color_rgb(150, 200, 255);
    var _luz  = make_color_rgb(255, 250, 220);

    draw_set_alpha(0.4);
    draw_circle_color(10, 10, 10, _halo, _halo, false);
    draw_set_alpha(1);
    draw_circle_color(10, 10, 5, _luz, _luz, false);
    draw_triangle_color(10, 0, 7, 10, 13, 10, _luz, _luz, _luz, false);
    draw_triangle_color(10, 20, 7, 10, 13, 10, _luz, _luz, _luz, false);

    surface_reset_target();
    global.spr_astral = sprite_create_from_surface(_s, 0, 0, 20, 20, false, false, 10, 10);
    surface_free(_s);
}
sprite_index = global.spr_astral;

aviso = 20;
vsp = 0;
vsp_max = 9;
image_alpha = 0.5;