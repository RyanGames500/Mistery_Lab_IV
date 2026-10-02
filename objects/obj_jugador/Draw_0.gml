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

    // --- 1. DIBUJAR EL SPRITE BASE DE COLISIÓN/FONDO PRIMERO ---
    // (Esto hace que se vea el nudo y las cuerdas base de tu imagen Layer 7)
    draw_self(); 

    var _num_partes = 11; // cantidad de subimágenes de spr_ramo_partes

    for (var i = 0; i < _num_partes; i++) {

        // Fase distinta por pieza para que no oscilen todas sincronizadas
        var _fase = i * 0.6;

        // --- Viento y balanceo fluido ---
        var _viento_time = current_time * 0.0015 + _fase;
        var _viento_x = sin(_viento_time) * 4; // Desplazamiento horizontal suave

        // --- Rotación de péndulo (clave para el efecto de globo) ---
        var _rotacion = sin(_viento_time) * 5.5; 

        // --- Deformación tipo globo (gelatina) ---
        var _gelatin_time = current_time * 0.006 + _fase;
        var _stretch_x = sin(_gelatin_time) * 0.035;
        var _stretch_y = cos(_gelatin_time) * 0.035;

        var _final_xscale = image_xscale * (1 + _stretch_x);
        var _final_yscale = image_yscale * (1 + _stretch_y);

        // Dibujamos cada pieza con su vaivén, su estiramiento y su rotación de péndulo
        draw_sprite_ext(spr_ramo_partes, i, x + _viento_x, y,
            _final_xscale, _final_yscale, _rotacion, image_blend, image_alpha);
    }
}
else {
    draw_self();
}