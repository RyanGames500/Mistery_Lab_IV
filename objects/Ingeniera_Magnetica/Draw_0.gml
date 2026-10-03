var _cy = (bbox_top + bbox_bottom) / 2;
var _t = current_time;

var _c1 = make_color_rgb(90, 200, 255);
var _c2 = make_color_rgb(150, 110, 255);

// Campo magnético
var _a = 0;
if (estado == ESTADO_IMAN.AVISO)  _a = 0.08 + 0.06 * sin(_t * 0.03);
if (estado == ESTADO_IMAN.ACTIVO) _a = 0.16;

if (_a > 0) {
    draw_set_alpha(_a);
    draw_rectangle_color(x - rango_vision, _cy - alto_campo, x + rango_vision, _cy + alto_campo,
        _c1, _c1, _c2, _c2, false);

    // Líneas que viajan hacia ella (solo cuando atrae)
    if (estado == ESTADO_IMAN.ACTIVO) {
        draw_set_alpha(0.7);
        for (var s = -1; s <= 1; s += 2) {
            for (var i = 0; i < 6; i++) {
                var _d = rango_vision - ((_t * 0.12 + i * 41) mod rango_vision);
                var _yy = _cy - alto_campo + 14 + i * ((alto_campo * 2 - 28) / 5);
                draw_line_width_color(x + s * _d, _yy, x + s * (_d + 14), _yy, 2, _c1, c_white);
            }
        }
    }
    draw_set_alpha(1);
}

// Aviso: anillo que se contrae hacia ella
if (estado == ESTADO_IMAN.AVISO) {
    var _r = 8 + (timer / tiempo_aviso) * 40;
    draw_set_alpha(0.8);
    draw_circle_color(x, _cy, _r, c_white, _c1, true);
    draw_set_alpha(1);
}

draw_self();