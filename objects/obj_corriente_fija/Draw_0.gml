var _dx = round(lengthdir_x(1, direccion));
var _dy = round(lengthdir_y(1, direccion));

// Colores: arriba = celeste, abajo = naranja, lados = violeta
var _c1, _c2;
if (_dy < 0)      { _c1 = make_color_rgb(150, 230, 255); _c2 = c_white; }
else if (_dy > 0) { _c1 = make_color_rgb(255, 160, 70);  _c2 = make_color_rgb(140, 70, 40); }
else              { _c1 = make_color_rgb(170, 130, 255); _c2 = make_color_rgb(150, 230, 255); }

// Transparencia según el estado
var _alfa = 0.2;
if (aviso_inv > 0)    _alfa = 0.06 + 0.06 * sin(current_time * 0.04);
else if (!activa)     _alfa = avisando ? 0.05 + 0.05 * sin(current_time * 0.03) : 0;
if (_alfa <= 0) exit;

var _x2 = x + ancho;
var _y2 = y + alto;

// Campo (el color brillante queda del lado hacia donde empuja)
draw_set_alpha(_alfa);
if (_dy < 0)      draw_rectangle_color(x, y, _x2, _y2, _c2, _c2, _c1, _c1, false);
else if (_dy > 0) draw_rectangle_color(x, y, _x2, _y2, _c1, _c1, _c2, _c2, false);
else if (_dx > 0) draw_rectangle_color(x, y, _x2, _y2, _c1, _c2, _c2, _c1, false);
else              draw_rectangle_color(x, y, _x2, _y2, _c2, _c1, _c1, _c2, false);

// Líneas de viento y flecha (solo cuando empuja de verdad)
if (activa && aviso_inv <= 0) {
    draw_set_alpha(0.7);
    var _n = clamp(floor(ancho * alto / 1500), 6, 30);
    var _largo = (_dx != 0) ? ancho : alto;

    for (var i = 0; i < _n; i++) {
        var _p = (current_time * 0.12 + i * 83) mod _largo;
        var _px, _py;

        if (_dx != 0) {
            _py = y + 8 + (i * 37) mod max(1, alto - 16);
            _px = (_dx > 0) ? x + _p : _x2 - _p;
        } else {
            _px = x + 8 + (i * 37) mod max(1, ancho - 16);
            _py = (_dy > 0) ? y + _p : _y2 - _p;
        }
        draw_line_width_color(_px, _py, _px - _dx * 10, _py - _dy * 10, 2, c_white, _c1);
    }

    // Flecha en el centro
    var _cx = x + ancho / 2;
    var _cy = y + alto / 2;
    draw_set_alpha(0.5);
    draw_triangle_color(_cx + _dx * 10, _cy + _dy * 10,
        _cx - _dx * 6 - _dy * 10, _cy - _dy * 6 + _dx * 10,
        _cx - _dx * 6 + _dy * 10, _cy - _dy * 6 - _dx * 10,
        c_white, c_white, c_white, false);
}

draw_set_alpha(1);