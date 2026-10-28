// --- Sprite por código (solo una vez) ---
if (!variable_global_exists("spr_orbe_reina")) {
    var _s = surface_create(26, 26);
    surface_set_target(_s);
    draw_clear_alpha(c_black, 0);

    var _borde = make_color_rgb(70, 40, 170);
    var _medio = make_color_rgb(150, 110, 255);
    var _luz   = make_color_rgb(255, 245, 170);

    draw_circle_color(13, 13, 12, _borde, _borde, false);
    draw_circle_color(13, 13, 10, _medio, _medio, false);
    draw_circle_color(13, 13, 5,  _luz,   _luz,   false);

    surface_reset_target();
    global.spr_orbe_reina = sprite_create_from_surface(_s, 0, 0, 26, 26, false, false, 13, 13);
    surface_free(_s);
}
sprite_index = global.spr_orbe_reina;

hsp = 0;        // lo asigna la Reina
aviso = 20;     // parpadea sin hacer daño antes de salir
vida = 420;     // seguro por si algo falla
image_alpha = 0.5;