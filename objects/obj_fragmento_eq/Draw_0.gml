if (aviso > 0) {
    draw_set_alpha(0.35);
    draw_line_width_color(x, y, x + lengthdir_x(140, dir_mov), y + lengthdir_y(140, dir_mov), 2, c_white, c_white);
    draw_set_alpha(1);
}
draw_self();