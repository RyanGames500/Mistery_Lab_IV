// --- Crear el sprite de la raíz por código (solo una vez) ---
if (!variable_global_exists("spr_raiz")) {
    var _w = 24;
    var _h = 48;
    var _s = surface_create(_w, _h);

    surface_set_target(_s);
    draw_clear_alpha(c_black, 0);

    var _marron  = make_color_rgb(90, 55, 30);
    var _claro   = make_color_rgb(140, 90, 50);
    var _verde   = make_color_rgb(110, 190, 90);

    // Cuerpo principal (espina curva)
    draw_triangle_color(3, 48, 21, 48, 14, 3, _marron, _marron, _marron, false);
    // Franja de luz
    draw_triangle_color(9, 48, 16, 48, 14, 8, _claro, _claro, _claro, false);
    // Espinas laterales
    draw_triangle_color(5, 38, 5, 28, 0, 34, _marron, _marron, _marron, false);
    draw_triangle_color(19, 30, 19, 20, 24, 26, _marron, _marron, _marron, false);
    // Punta con brillo verde (corrupción / vida)
    draw_triangle_color(12, 14, 16, 14, 14, 3, _verde, _verde, _verde, false);

    surface_reset_target();

    // Origen: abajo al centro (para que quede pegada al suelo)
    global.spr_raiz = sprite_create_from_surface(_s, 0, 0, _w, _h, false, false, _w / 2, _h);
    surface_free(_s);
}

sprite_index = global.spr_raiz;

fase = 0;                 // 0 = aviso, 1 = activa
timer = 15;
image_yscale = 0.25;      // asoma pequeña en el aviso
image_xscale = choose(1, -1);  // variedad visual
image_blend = c_gray;     // oscurecida mientras avisa