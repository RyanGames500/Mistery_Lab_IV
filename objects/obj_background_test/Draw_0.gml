// Fondo Test
draw_clear(make_color_rgb(220, 220, 220)); 
var grid_size = 64;
var grid_color = make_color_rgb(200, 200, 200); 
for (var i = 0; i <= room_width; i += grid_size) {
    draw_line_color(i, 0, i, room_height, grid_color, grid_color);
}
for (var j = 0; j <= room_height; j += grid_size) {
    draw_line_color(0, j, room_width, j, grid_color, grid_color);
}