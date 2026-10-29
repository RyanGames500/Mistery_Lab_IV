// 1. Estela de la pelota (TF1)
if (is_transformed && transform_type == 1 && vsp > 10) {
    draw_sprite_ext(sprite_index, image_index, x, y - 10, image_xscale * 1.1, image_yscale * 1.1, image_angle, c_white, 0.3);
    draw_sprite_ext(sprite_index, image_index, x, y - 20, image_xscale * 1.2, image_yscale * 1.2, image_angle, c_white, 0.15);
}

// 2. Dibujado principal por estados
if (flash_timer > 0) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, 1);
} 
else if (is_transformed && transform_type == 3) {
    // --- EFECTO GELATINOSO DEL GLOBO ---
    var _final_xscale = image_xscale;
    var _final_yscale = image_yscale;
    
    if (!is_dashing) {
        var _gelatin_time = current_time * 0.006;
        var _stretch_x = sin(_gelatin_time) * 0.035;
        var _stretch_y = cos(_gelatin_time) * 0.035;
        
        if (abs(hsp) > 0.2) {
            _stretch_x += sign(hsp) * (abs(hsp) * 0.02);
            _stretch_y -= abs(hsp) * 0.02; 
        }
        if (abs(vsp) > 0.2) {
            _stretch_y += (vsp * 0.015); 
            _stretch_x -= abs(vsp) * 0.01;
        }
        _final_xscale += _stretch_x;
        _final_yscale += _stretch_y;
    }
    draw_sprite_ext(sprite_index, image_index, x, y, _final_xscale, _final_yscale, image_angle, image_blend, image_alpha);
}
else if (is_transformed && transform_type == 4) {
    // --- EFECTO VISUAL DE LA NUBE (Gelatinoso sutil + Parpadeo de Fase integrado) ---
    var _gelatin_time = current_time * 0.005;
    var _stretch_x = sin(_gelatin_time) * 0.025;
    var _stretch_y = cos(_gelatin_time) * 0.025;
    
    if (abs(hsp) > 0.2) {
        _stretch_x += sign(hsp) * (abs(hsp) * 0.015);
        _stretch_y -= abs(hsp) * 0.015;
    }
    if (abs(vsp) > 0.2) {
        _stretch_y += (vsp * 0.015);
        _stretch_x -= abs(vsp) * 0.01;
    }
    
    var _final_xscale = image_xscale + _stretch_x;
    var _final_yscale = image_yscale + _stretch_y;
    
    var _alpha_actual = image_alpha;
    var _blend_actual = image_blend;
    
    if (nube_fase_active) {
        if (((current_time div 80) % 2) == 0) {
            _alpha_actual = 0.4;
            _blend_actual = c_aqua; 
        } else {
            _alpha_actual = 1.0;
            _blend_actual = c_white;
        }
    }
    
    draw_sprite_ext(sprite_index, image_index, x, y, _final_xscale, _final_yscale, image_angle, _blend_actual, _alpha_actual);
}
else if (is_transformed && transform_type == 10) {
    globos_medusa_dibujar();
}
else if (is_transformed && (transform_type == 11 || transform_type == 12)) {
    // --- EFECTO RESPIRACIÓN / GELATINA (Hada y Arpia) ---
    var _gelatin_time = current_time * 0.006;
    var _stretch_x = sin(_gelatin_time) * 0.035;
    var _stretch_y = cos(_gelatin_time) * 0.035;

    if (abs(hsp) > 0.2) {
        _stretch_x += sign(hsp) * (abs(hsp) * 0.015);
        _stretch_y -= abs(hsp) * 0.015;
    }
    if (abs(vsp) > 0.2) {
        _stretch_y += (vsp * 0.012);
        _stretch_x -= abs(vsp) * 0.008;
    }

    var _final_xscale = image_xscale + (_stretch_x * escala_tf);
    var _final_yscale = image_yscale + (_stretch_y * escala_tf);

    draw_sprite_ext(sprite_index, image_index, x, y, _final_xscale, _final_yscale, image_angle, image_blend, image_alpha);
}
else {
    draw_self();
}