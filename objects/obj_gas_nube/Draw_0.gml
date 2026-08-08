// Configuramos color morado/verdoso de gas tóxico y transparencia
draw_set_alpha(0.4);
draw_set_color(c_purple);

// Dibujamos varios círculos solapados para simular una forma orgánica de humo/gas
draw_circle(x, y, 24 * escala_actual, false);
draw_circle(x - 12, y + 4, 18 * escala_actual, false);
draw_circle(x + 12, y + 4, 18 * escala_actual, false);
draw_circle(x, y - 10, 16 * escala_actual, false);

// Restauramos los valores por defecto para que no afecte a otros sprites
draw_set_alpha(1);
draw_set_color(c_white);