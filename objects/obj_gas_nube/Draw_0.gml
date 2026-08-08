
draw_set_alpha(0.4);
draw_set_color(c_purple);

draw_circle(x, y, 24 * escala_actual, false);
draw_circle(x - 12, y + 4, 18 * escala_actual, false);
draw_circle(x + 12, y + 4, 18 * escala_actual, false);
draw_circle(x, y - 10, 16 * escala_actual, false);

draw_set_alpha(1);
draw_set_color(c_white);