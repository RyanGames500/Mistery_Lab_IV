var _luz = (tipo < 0);
var _c1 = _luz ? make_color_rgb(150, 230, 255) : make_color_rgb(255, 160, 70);
var _c2 = _luz ? c_white : make_color_rgb(140, 70, 40);

var _alfa = (aviso > 0) ? 0.07 + 0.05 * sin(current_time * 0.03) : 0.2;
if (timer < 30) _alfa *= timer / 30;

draw_set_alpha(_alfa);
draw_rectangle_color(z_x1, z_y1, z_x2, z_y2, _c1, _c1, _c2, _c2, false);

// Partículas: suben en zona ligera, caen en zona pesada
draw_set_alpha(min(0.8, _alfa * 4));
var _alto = z_y2 - z_y1;
var _ancho = z_x2 - z_x1;
for (var i = 0; i < 14; i++) {
    var _px = z_x1 + 8 + (i * 37) mod max(1, _ancho - 16);
    var _off = (current_time * 0.12 + i * 83) mod _alto;
    var _py = _luz ? z_y2 - _off : z_y1 + _off;
    draw_circle_color(_px, _py, 2, c_white, _c1, false);
}

// Flecha en el centro de la pantalla (arriba = ligera, abajo = pesada)
var _mx = (z_x1 + z_x2) / 2;
var _my = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2;
draw_set_alpha(min(0.8, _alfa * 4));
if (_luz) draw_triangle_color(_mx, _my - 14, _mx - 10, _my + 6, _mx + 10, _my + 6, c_white, c_white, c_white, false);
else      draw_triangle_color(_mx, _my + 14, _mx - 10, _my - 6, _mx + 10, _my - 6, c_white, c_white, c_white, false);

draw_set_alpha(1);