var _t = current_time / 1000;
var _bob = sin(_t * 2) * 4;
var _a = ((inv_timer > 0) && (inv_timer mod 4 < 2)) ? 0.4 : 1;
if (estado == ESTADO_REINA.CANSADA) _a *= 0.75;

var _c_ala   = make_color_rgb(110, 160, 255);
var _c_borde = make_color_rgb(70, 90, 200);
var _c_luz   = make_color_rgb(255, 235, 150);
var _c_vest  = make_color_rgb(140, 120, 255);

// Telegrafía de la embestida (línea de trayectoria)
if (estado == ESTADO_REINA.APUNTANDO && timer <= 25) {
    draw_set_alpha(0.7);
    draw_line_width_color(x, y, x + lengthdir_x(1500, emb_dir), y + lengthdir_y(1500, emb_dir),
        4, make_color_rgb(255, 120, 60), make_color_rgb(255, 200, 120));
}

// Brillo de aviso
if (estado == ESTADO_REINA.AVISO) {
    draw_set_alpha(0.35 + 0.2 * sin(_t * 20));
    draw_circle_color(x, y + _bob, 64, _c_luz, _c_luz, false);
}

// Seis alas translúcidas con contorno
for (var i = 0; i < 6; i++) {
    var _lado = (i mod 2 == 0) ? 1 : -1;
    var _fila = i div 2;
    var _ang = 90 + _lado * (30 + _fila * 40) + sin(_t * 3 + i) * 8;
    var _len = 74 - _fila * 12;

    var _bx = x;
    var _by = y + _bob - 10;
    var _ex = _bx + lengthdir_x(_len, _ang);
    var _ey = _by + lengthdir_y(_len, _ang);
    var _ox = lengthdir_x(14, _ang + 90);
    var _oy = lengthdir_y(14, _ang + 90);

    draw_set_alpha(0.6 * _a);
    draw_triangle_color(_bx, _by, _ex + _ox, _ey + _oy, _ex - _ox, _ey - _oy, _c_ala, _c_ala, _c_luz, false);
    draw_set_alpha(0.9 * _a);
    draw_triangle_color(_bx, _by, _ex + _ox, _ey + _oy, _ex - _ox, _ey - _oy, _c_borde, _c_borde, _c_borde, true);
}

// Vestido-nube
draw_set_alpha(0.8 * _a);
draw_circle_color(x, y + _bob + 20, 26, _c_vest, _c_vest, false);
draw_circle_color(x - 14, y + _bob + 26, 18, _c_vest, _c_vest, false);
draw_circle_color(x + 14, y + _bob + 26, 18, _c_vest, _c_vest, false);
draw_set_alpha(1 * _a);
draw_circle_color(x, y + _bob + 8, 16, _c_luz, _c_vest, false);
draw_circle_color(x, y + _bob + 8, 16, _c_borde, _c_borde, true);

// Cabeza y cabello flotando
draw_set_alpha(1 * _a);
draw_circle_color(x, y + _bob - 18, 9, _c_luz, _c_luz, false);
draw_circle_color(x, y + _bob - 18, 9, _c_borde, _c_borde, true);
for (var h = -2; h <= 2; h++) {
    draw_set_alpha(0.8 * _a);
    draw_line_width_color(x + h * 3, y + _bob - 24,
        x + h * 7 + sin(_t * 2 + h) * 6, y + _bob + 6,
        2, _c_luz, _c_ala);
}

// Partículas de luz orbitando
for (var p = 0; p < 8; p++) {
    var _pa = _t * 60 + p * 45;
    var _pr = 36 + sin(_t * 2 + p) * 10;
    draw_set_alpha(1 * _a);
    draw_circle_color(x + lengthdir_x(_pr, _pa), y + _bob + lengthdir_y(_pr, _pa) * 0.8, 3, _c_luz, _c_borde, false);
}

draw_set_alpha(1);