// --- Sprite del proyectil por código (solo una vez) ---
if (!variable_global_exists("spr_proyectil_guardiana")) {
    var _w = 20;
    var _h = 20;
    var _s = surface_create(_w, _h);

    surface_set_target(_s);
    draw_clear_alpha(c_black, 0);

    var _halo   = make_color_rgb(120, 200, 255);
    var _medio  = make_color_rgb(150, 110, 255);
    var _nucleo = make_color_rgb(235, 245, 255);

    // Halo suave
    draw_set_alpha(0.25);
    draw_circle_color(10, 10, 10, _halo, _halo, false);
    draw_set_alpha(0.55);
    draw_circle_color(10, 10, 8, _halo, _halo, false);

    // Cuerpo y núcleo
    draw_set_alpha(1);
    draw_circle_color(10, 10, 6, _medio, _medio, false);
    draw_circle_color(10, 10, 3, _nucleo, _nucleo, false);

    // Destello cruzado (da aspecto de energía dimensional)
    draw_triangle_color(10, 1, 8, 10, 12, 10, _nucleo, _nucleo, _nucleo, false);
    draw_triangle_color(10, 19, 8, 10, 12, 10, _nucleo, _nucleo, _nucleo, false);

    surface_reset_target();

    global.spr_proyectil_guardiana = sprite_create_from_surface(_s, 0, 0, _w, _h, false, false, _w / 2, _h / 2);
    surface_free(_s);
}

sprite_index = global.spr_proyectil_guardiana;

hsp = 0;                 // los asigna la Guardiana al crearlo
vsp = 0;
grav = 0.25;
rebotes_restantes = 1;   // rebota una sola vez
vida = 240;              // frames máximos de vida