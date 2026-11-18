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
else if (is_transformed && transform_type == 13) {
    // --- IMÁN: gira para que los polos miren a la superficie donde está pegada ---
    var _ang_meta = 0;
    var _off_x = 0;
    var _off_y = 0;
    if (iman_pegado && !is_hit) {
        switch (iman_superficie) {
            case "suelo": _ang_meta = 180; _off_y = -12; break;
            case "techo": _ang_meta = 0;   _off_y = 12;  break;
            case "izq":   _ang_meta = 90;  _off_x = 13;  break;
            case "der":   _ang_meta = 270; _off_x = -13; break;
        }
    }
    iman_ang += angle_difference(_ang_meta, iman_ang) * 0.25;

    // Gira desde el centro del imán (el origen del sprite está abajo)
    var _medio = 33 * abs(image_yscale);
    var _cx = x + _off_x;
    var _cy = y - _medio + _off_y;
    var _dx = _cx + lengthdir_x(_medio, iman_ang - 90);
    var _dy = _cy + lengthdir_y(_medio, iman_ang - 90);

    var _blend = image_blend;
    if (is_hit && !golpe_iman_especial && ((current_time div 80) mod 2) == 0) _blend = c_red;

    // Brillo azul cuando está imantada
    if (iman_pegado) {
        gpu_set_blendmode(bm_add);
        draw_sprite_ext(sprite_index, image_index, _dx, _dy, image_xscale * iman_sx * 1.08, image_yscale * iman_sy * 1.08, iman_ang, make_color_rgb(90, 200, 255), 0.35 * image_alpha);
        gpu_set_blendmode(bm_normal);
    }

    draw_sprite_ext(sprite_index, image_index, _dx, _dy, image_xscale * iman_sx, image_yscale * iman_sy, iman_ang, _blend, image_alpha);

    // Onda de repulsión (Z)
    if (iman_onda_timer > 0) {
        var _p = 1 - (iman_onda_timer / 20);
        draw_set_alpha(1 - _p);
        draw_circle_color(iman_onda_x, iman_onda_y, 10 + (iman_repel_radio - 10) * _p, c_red, c_red, true);
        draw_circle_color(iman_onda_x, iman_onda_y, 6 + (iman_repel_radio * 0.6) * _p, c_white, c_white, true);
        draw_set_alpha(1);
        iman_onda_timer--;
    }
}
else {
    draw_self();
}