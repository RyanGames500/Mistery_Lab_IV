// Velo oscuro con Gaby iluminada encima
if (dim_t > 0) {
    var _env = min(1, (dim_len - dim_t) / 6, dim_t / 20);
    var _cam = view_camera[0];
    var _vx = camera_get_view_x(_cam);
    var _vy = camera_get_view_y(_cam);
    var _vw = camera_get_view_width(_cam);
    var _vh = camera_get_view_height(_cam);

    draw_set_alpha(0.55 * _env * min(k, 1.2));
    draw_set_color(make_color_rgb(5, 2, 12));
    draw_rectangle(_vx - 4, _vy - 4, _vx + _vw + 4, _vy + _vh + 4, false);
    draw_set_alpha(1);

    if (instance_exists(obj_jugador)) {
        with (obj_jugador) event_perform(ev_draw, 0);
    }
}

// Ondas de choque
for (var i = 0; i < array_length(rings); i++) {
    var _o = rings[i];
    if (_o.delay > 0) continue;
    var _pr = _o.t / _o.life;
    var _e = 1 - power(1 - _pr, 3);
    var _rad = 10 + _o.r1 * _e;
    draw_set_alpha(1 - _pr);
    draw_set_color(c1);
    var _th = 1 + 5 * (1 - _pr);
    for (var w = 0; w < _th; w++) draw_circle(x, y, _rad + w, true);
}

// Chispas
for (var i = 0; i < array_length(sparks); i++) {
    var _p = sparks[i];
    draw_set_alpha(max(0, 1 - _p.t / _p.life));
    draw_set_color(_p.c);
    draw_rectangle(_p.x - _p.s / 2, _p.y - _p.s / 2, _p.x + _p.s / 2, _p.y + _p.s / 2, false);
}

draw_set_alpha(1);
draw_set_color(c_white);