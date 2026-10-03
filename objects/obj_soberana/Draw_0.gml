var _t = current_time / 1000;
var _bob = sin(_t * 2) * 3;
var _a = ((inv_timer > 0) && (inv_timer mod 4 < 2)) ? 0.45 : 1;
if (estado == ESTADO_SOB.RUP_MARCA) _a *= 0.3 + 0.3 * abs(sin(_t * 18));
if (estado == ESTADO_SOB.CANSADA) _a *= 0.8;

var _bx = x + random_range(-temblor, temblor);
var _by = y + _bob;

var _mat1  = make_color_rgb(125, 112, 100);
var _mat2  = make_color_rgb(80, 72, 68);
var _en1   = make_color_rgb(110, 225, 255);
var _borde = make_color_rgb(40, 36, 44);
var _piel  = make_color_rgb(235, 215, 205);
var _viol  = make_color_rgb(160, 120, 255);

// Qué lado es materia y cuál energía (se alternan)
var _swap = (sin(_t * 1.6) > 0);
var _cl = _swap ? _mat1 : _en1;
var _cr = _swap ? _en1 : _mat1;

// --- Portal y zona de peligro del destino (Ruptura) ---
if (estado == ESTADO_SOB.RUP_MARCA) {
    var _tot = (fase == 1) ? 38 : 28;
    var _k = clamp(timer / _tot, 0, 1);
    var _rm = (fase == 1) ? 140 : 170;
    draw_set_alpha(0.12);
    draw_circle_color(dest_x, dest_y, _rm, c_red, c_red, false);
    draw_set_alpha(0.5);
    draw_circle_color(dest_x, dest_y, _rm, c_red, c_red, true);
    draw_set_alpha(0.9);
    draw_circle_color(dest_x, dest_y, 12 + _k * 36, _en1, _viol, true);
}

// --- Brillo de aviso ---
if (estado == ESTADO_SOB.AVISO) {
    draw_set_alpha(0.22 + 0.12 * sin(_t * 20));
    draw_circle_color(_bx, _by, 54, c_white, _en1, false);
}

// --- Anillos dimensionales (detrás) ---
for (var r = 0; r < 3; r++) {
    var _rad = 56 + r * 14;
    var _w = _rad * abs(cos(_t * (1.2 + r * 0.45) + r));
    var _cc = (r mod 2 == 0) ? _viol : _en1;
    draw_set_alpha(0.6 * _a);
    draw_ellipse_color(_bx - _w, _by - _rad, _bx + _w, _by + _rad, _cc, _cc, true);
    draw_ellipse_color(_bx - _w - 1, _by - _rad - 1, _bx + _w + 1, _by + _rad + 1, _cc, _cc, true);
}

// --- Brazos (l = 0) y piernas (l = 1): materia o energía alternando ---
for (var l = 0; l < 2; l++) {
    for (var s = -1; s <= 1; s += 2) {
        var _mat = (l == 0) ? ((s == 1) == _swap) : ((s == 1) != _swap);
        var _sx, _sy, _ex, _ey;

        if (l == 0) {
            _sx = _bx + s * 10;
            _sy = _by - 14;
            _ex = _sx + s * (14 + sin(_t * 2 + s) * 3);
            _ey = _sy + 22 + cos(_t * 2 + s) * 3 - ((estado == ESTADO_SOB.AVISO) ? 44 : 0);
        } else {
            _sx = _bx + s * 5;
            _sy = _by + 8;
            _ex = _sx + s * 3 + sin(_t * 3 + s) * 2;
            _ey = _by + 36;
        }

        if (_mat) {
            draw_set_alpha(_a);
            draw_line_width_color(_sx, _sy, _ex, _ey, 9, _mat2, _mat2);
            draw_rectangle_color(_ex - 6, _ey - 6, _ex + 6, _ey + 6, _mat1, _mat1, _mat2, _mat2, false);
            draw_rectangle_color(_ex - 6, _ey - 6, _ex + 6, _ey + 6, _borde, _borde, _borde, _borde, true);
        } else {
            draw_set_alpha(0.5 * _a);
            draw_line_width_color(_sx, _sy, _ex, _ey, 11, _en1, _en1);
            draw_set_alpha(_a);
            draw_line_width_color(_sx, _sy, _ex, _ey, 4, c_white, _en1);
            draw_circle_color(_ex, _ey, 5, c_white, _en1, false);
        }
    }
}

// --- Vestido de fragmentos ---
for (var k = -2; k <= 2; k++) {
    var _dm = (abs(k) mod 2 == 0);
    var _cc2 = _dm ? _mat1 : _en1;
    var _dx = _bx + k * 7;
    draw_set_alpha((_dm ? 0.95 : 0.65) * _a);
    draw_triangle_color(_dx - 6, _by - 4, _dx + 6, _by - 4,
        _dx + sin(_t * 2 + k) * 3, _by + 24 + abs(k) * 2, _cc2, _cc2, _viol, false);
}

// --- Torso (materia a un lado, energía al otro) ---
draw_set_alpha(_a);
draw_rectangle_color(_bx - 9, _by - 18, _bx + 9, _by + 4, _cl, _cr, _cr, _cl, false);
draw_rectangle_color(_bx - 9, _by - 18, _bx + 9, _by + 4, _borde, _borde, _borde, _borde, true);

// --- Cabeza y cabello flotando ---
draw_circle_color(_bx, _by - 28, 8, _piel, _piel, false);
draw_circle_color(_bx, _by - 28, 8, _borde, _borde, true);
for (var h = -2; h <= 2; h++) {
    draw_set_alpha(0.7 * _a);
    draw_line_width_color(_bx + h * 3, _by - 35, _bx + h * 7 + sin(_t * 2 + h) * 6, _by - 12, 2, _en1, _viol);
}
draw_set_alpha(_a);
draw_circle_color(_bx - 3, _by - 28, 1.5, _en1, _en1, false);
draw_circle_color(_bx + 3, _by - 28, 1.5, _en1, _en1, false);

draw_set_alpha(1);