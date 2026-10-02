


// --- EFECTO DE CÍRCULO MAGNÉTICO ---
if (magnet_cooldown <= 0 && magnet_duration > 0) {
    draw_set_alpha(0.3);
    draw_set_color(c_aqua);
    draw_circle(x, y, rango_magnet * (magnet_duration / 60), true);
    draw_set_alpha(1);
    
    // --- ZARCILLOS / "FIDEOS" MAGNÉTICOS ONDULANTES ---
    // Inicializamos un temporizador interno para la animación si no existe
    if (!variable_instance_exists(id, "magnet_timer")) {
        magnet_timer = 0;
    }
    magnet_timer += 0.25; // Velocidad con la que se mueven y ondulan las líneas
    
    draw_set_color(c_aqua);
    var _num_tendrils = 6; // Cantidad de "fideos" de energía
    
    for (var i = 0; i < _num_tendrils; i++) {
        // Distribuimos las líneas en círculo y las hacemos girar suavemente
        var _angle = (360 / _num_tendrils) * i + (magnet_timer * 8);
        var _max_dist = rango_magnet * (magnet_duration / 60);
        
        var _prev_x = x;
        var _prev_y = y;
        
        // Dividimos cada línea en segmentos para crear la curva suave tipo serpiente/fideo
        var _segments = 6;
        for (var j = 1; j <= _segments; j++) {
            var _dist_ratio = j / _segments;
            var _current_dist = _max_dist * _dist_ratio;
            
            // Efecto de ondulación con seno (crea la curva fluida)
            var _wave = sin(magnet_timer + (j * 0.6) + i) * 10 * (1 - _dist_ratio);
            
            var _px = x + lengthdir_x(_current_dist, _angle) + lengthdir_x(_wave, _angle + 90);
            var _py = y + lengthdir_y(_current_dist, _angle) + lengthdir_y(_wave, _angle + 90);
            
            // Dibujamos un trazo grueso y estilizado
            draw_line_width(_prev_x, _prev_y, _px, _py, 2.5);
            
            _prev_x = _px;
            _prev_y = _py;
        }
    }
}

// Dibuja el sprite normal de la ingeniera
draw_self();
// --- EFECTO VISUAL CUANDO ESTÁ CARGANDO (AVISO) ---
if (cargando_iman) {
    if ((magnet_cooldown % 6) < 3) {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, 0.6);
    }
}