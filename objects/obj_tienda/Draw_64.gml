if (!activo) exit;

draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(200, 100, 830, 520, false);
draw_set_alpha(1.0);

draw_set_color(c_white);
draw_text(240, 130, "=== TIENDA DE GABY ===");
draw_text(630, 130, "Monedas: " + string(global.coins));

for (var i = 0; i < array_length(items); i++) {
    var _item = items[i];
    var _is_bought = variable_global_get(_item.bought_var);
    var _y = 210 + (i * 65);

    if (i == selected_index) {
        draw_set_color(c_yellow);
        draw_text(220, _y, ">");
    } else {
        draw_set_color(c_white);
    }
    
    var _status = _is_bought ? "[ADQUIRIDO]" : string(_item.price) + " Monedas";
    draw_text(250, _y, _item.name + "  ---  " + _status);
}

draw_set_color(c_gray);
draw_text(240, 470, "Usa W/S o Flechas para navegar | ENTER/Z para comprar | ESC para salir");