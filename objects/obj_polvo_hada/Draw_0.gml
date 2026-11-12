var _a = clamp(vida / vida_max * 2, 0, 1);   // se desvanece al final
var _p = 1 + sin(t * 0.5) * 0.2;
draw_set_alpha(_a);

// brillo exterior
draw_set_color(make_color_rgb(255, 150, 255));
draw_circle(x, y, 5 * _p, false);
// núcleo
draw_set_color(c_white);
draw_circle(x, y, 2.5 * _p, false);
// cuatro puntas girando
var _ang = t * 12;
for (var i = 0; i < 4; i++) {
    var _d = _ang + i * 90;
    draw_line_width(x, y, x + lengthdir_x(8 * _p, _d), y + lengthdir_y(8 * _p, _d), 1);
}

draw_set_alpha(1);
draw_set_color(c_white);