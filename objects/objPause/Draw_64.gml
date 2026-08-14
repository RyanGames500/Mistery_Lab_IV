if (pause) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    if (!surface_exists(pauseSurface)) {
        pauseSurface = surface_create(_gui_w, _gui_h);
        surface_set_target(pauseSurface);
        
        // Copiamos la pantalla actual estirada a la medida exacta de la GUI
        draw_surface_stretched(application_surface, 0, 0, _gui_w, _gui_h);
        surface_reset_target();
        
        instance_deactivate_all(true);
    }
    
    // Dibujamos la surface cubriendo toda la pantalla de la GUI
    draw_surface(pauseSurface, 0, 0);
    
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    
    draw_set_font(fnt_small);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _cx = _gui_w / 2;
    var _cy = _gui_h / 2;
    
    // Título
    draw_set_color(c_yellow);
    draw_text(_cx, _cy - 80, tr("msg_pausa"));
    
    // --- LÓGICA DE INPUT (Teclado y Táctil) ---
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _touch = device_mouse_check_button_pressed(0, mb_left);
    
    var _btn_w = 400;
    var _btn_h = 50;
    var _x1 = _cx - (_btn_w / 2);
    var _y_cont = _cy - 10;
    var _y_salir = _cy + 60;
    
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_up)) {
        selected = !selected;
    }
    
    if (point_in_rectangle(_mx, _my, _x1, _y_cont, _x1 + _btn_w, _y_cont + _btn_h)) {
        selected = 0;
        if (_touch) { 
            pause = false; 
            if (surface_exists(pauseSurface)) surface_free(pauseSurface); 
            instance_activate_all(); 
            audio_resume_all(); 
            exit; 
        }
    }
    else if (point_in_rectangle(_mx, _my, _x1, _y_salir, _x1 + _btn_w, _y_salir + _btn_h)) {
        selected = 1;
        if (_touch) { 
            instance_activate_all(); 
            room_goto(rm_main); 
            exit; 
        }
    }
    
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z"))) {
        if (selected == 0) {
            pause = false;
            if (surface_exists(pauseSurface)) surface_free(pauseSurface);
            instance_activate_all();
            audio_resume_all();
        } else {
            pause = false;
            instance_activate_all();
            room_goto(rm_main);
        }
    }
    
    var _color_cont = (selected == 0) ? c_white : c_gray;
    var _color_salir = (selected == 1) ? c_white : c_gray;
    
    draw_set_color(_color_cont);
    draw_text(_cx, _y_cont + 25, tr("msg_continuar"));
    
    draw_set_color(_color_salir);
    draw_text(_cx, _y_salir + 25, tr("msg_salir_menu"));
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}