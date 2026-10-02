var _alfa = (aviso > 0) ? 0.08 : 0.2;
if (timer < 30) _alfa *= timer / 30;

draw_set_alpha(_alfa);
draw_rectangle_color(x - ancho / 2, y_top, x + ancho / 2, y_bot,
    c_white, c_white, make_color_rgb(150, 200, 255), make_color_rgb(150, 200, 255), false);

// Partículas subiendo
draw_set_alpha(min(0.8, _alfa * 4));
var _alto = y_bot - y_top;
for (var i = 0; i < 12; i++) {
    var _px = x - ancho / 2 + 10 + (i * 37) mod (ancho - 20);
    var _py = y_bot - ((current_time * 0.25 + i * 97) mod _alto);
    draw_circle_color(_px, _py, 2, c_white, c_white, false);
}
draw_set_alpha(1);