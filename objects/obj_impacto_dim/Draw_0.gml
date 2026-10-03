var _fade = (r >= r_max) ? vida_post / 12 : 1;
var _c1 = make_color_rgb(110, 225, 255);
var _c2 = make_color_rgb(255, 190, 90);

draw_set_alpha(0.9 * _fade);
for (var k = -grosor / 2; k <= grosor / 2; k += 3) {
    var _rr = max(1, r + k);
    var _col = merge_color(_c1, _c2, (k + grosor / 2) / grosor);
    draw_circle_color(x, y, _rr, _col, _col, true);
}
draw_set_alpha(1);