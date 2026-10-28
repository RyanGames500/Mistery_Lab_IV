var _t = current_time / 1000;
var _a = ((inv_timer > 0) && (inv_timer mod 4 < 2)) ? 0.5 : 1;
var _bx = x + random_range(-temblor, temblor);
var _by = y;

var _roca  = make_color_rgb(125, 112, 100);
var _roca2 = make_color_rgb(88, 78, 72);
var _acero = make_color_rgb(150, 165, 185);
var _borde = make_color_rgb(40, 36, 44);
var _glow  = make_color_rgb(255, 210, 120);
if (estado == ESTADO_EMP.NUCLEO) _glow = make_color_rgb(90, 210, 255);
if (estado == ESTADO_EMP.AVISO)  _glow = make_color_rgb(255, 130, 50);
if (estado == ESTADO_EMP.ATURDIDA) _glow = make_color_rgb(120, 120, 130);

// --- Campo magnético ---
var _cy = y - 48;
if (estado == ESTADO_EMP.NUCLEO || (estado == ESTADO_EMP.AVISO && ataque_actual == 1)) {
    var _c1 = make_color_rgb(90, 200, 255);
    var _c2 = make_color_rgb(150, 110, 255);
    draw_set_alpha((estado == ESTADO_EMP.NUCLEO) ? 0.14 : 0.07 + 0.05 * sin(_t * 20));
    draw_rectangle_color(x - rango_nucleo, _cy - alto_nucleo, x + rango_nucleo, _cy + alto_nucleo,
        _c1, _c1, _c2, _c2, false);

    if (estado == ESTADO_EMP.NUCLEO) {
        draw_set_alpha(0.6);
        for (var s = -1; s <= 1; s += 2) {
            for (var i = 0; i < 7; i++) {
                var _d = rango_nucleo - ((current_time * 0.18 + i * 61) mod rango_nucleo);
                var _yy = _cy - alto_nucleo + 16 + i * ((alto_nucleo * 2 - 32) / 6);
                draw_line_width_color(x + s * _d, _yy, x + s * (_d + 18), _yy, 2, _c1, c_white);
            }
        }
    }
    draw_set_alpha(1);
}

// --- Línea de trayectoria de la carga ---
if (estado == ESTADO_EMP.AVISO && ataque_actual == 2 && timer <= 25) {
    draw_set_alpha(0.6);
    draw_line_width_color(_bx, _by - 8, _bx + carga_dir * 700, _by - 8, 4,
        c_red, make_color_rgb(255, 160, 80));
    draw_set_alpha(1);
}

draw_set_alpha(_a);

// --- Piernas ---
draw_rectangle_color(_bx - 24, _by - 32, _bx - 4, _by, _roca2, _roca2, _roca2, _roca2, false);
draw_rectangle_color(_bx + 4,  _by - 32, _bx + 24, _by, _roca2, _roca2, _roca2, _roca2, false);
draw_rectangle_color(_bx - 24, _by - 32, _bx - 4, _by, _borde, _borde, _borde, _borde, true);
draw_rectangle_color(_bx + 4,  _by - 32, _bx + 24, _by, _borde, _borde, _borde, _borde, true);

// --- Torso ---
draw_rectangle_color(_bx - 28, _by - 72, _bx + 28, _by - 28, _roca, _roca, _roca2, _roca2, false);
draw_rectangle_color(_bx - 28, _by - 72, _bx + 28, _by - 28, _borde, _borde, _borde, _borde, true);
draw_rectangle_color(_bx - 28, _by - 52, _bx + 28, _by - 46, _acero, _acero, _acero, _acero, false);

// --- Cabeza ---
draw_rectangle_color(_bx - 13, _by - 94, _bx + 13, _by - 72, _roca2, _roca2, _roca, _roca, false);
draw_rectangle_color(_bx - 13, _by - 94, _bx + 13, _by - 72, _borde, _borde, _borde, _borde, true);
draw_rectangle_color(_bx + dir * 3 - 7, _by - 86, _bx + dir * 3 + 7, _by - 82, _glow, _glow, _glow, _glow, false);

// --- Núcleo en el pecho ---
draw_circle_color(_bx, _by - 40, 9, _glow, _glow, false);
draw_circle_color(_bx, _by - 40, 9, _borde, _borde, true);

// --- Brazos ---
for (var b = -1; b <= 1; b += 2) {
    var _sx = _bx + b * 30;
    var _sy = _by - 66;
    var _hx = _sx + b * 14;
    var _hy = lerp(_sy + 38, _sy - 40, brazo);
    draw_line_width_color(_sx, _sy, _hx, _hy, 14, _roca2, _roca2);
    draw_rectangle_color(_hx - 11, _hy - 11, _hx + 11, _hy + 11, _roca, _roca, _roca2, _roca2, false);
    draw_rectangle_color(_hx - 11, _hy - 11, _hx + 11, _hy + 11, _borde, _borde, _borde, _borde, true);
}

// --- Bloques flotantes que se reorganizan ---
for (var k = 0; k < 4; k++) {
    var _ang = _t * 40 + k * 90;
    var _px = _bx + lengthdir_x(46 + sin(_t * 2 + k) * 6, _ang);
    var _py = _by - 52 + lengthdir_y(30 + cos(_t * 2 + k) * 6, _ang);
    draw_rectangle_color(_px - 5, _py - 5, _px + 5, _py + 5, _acero, _acero, _roca, _roca, false);
    draw_rectangle_color(_px - 5, _py - 5, _px + 5, _py + 5, _borde, _borde, _borde, _borde, true);
}

// --- Estrellitas cuando está aturdida ---
if (estado == ESTADO_EMP.ATURDIDA) {
    for (var q = 0; q < 3; q++) {
        var _qa = _t * 200 + q * 120;
        draw_circle_color(_bx + lengthdir_x(20, _qa), _by - 104 + lengthdir_y(5, _qa), 3,
            c_yellow, c_yellow, false);
    }
}

draw_set_alpha(1);