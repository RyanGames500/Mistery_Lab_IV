if (os_type == os_windows)
{
    draw_sprite_ext(spr_portrait_face, 0, 30, 60, 1.2, 1.2, 0, c_white, 1); 

    var _start_x = 120; 
    var _start_y = 65; 

    for (var i = 0; i < 3; i++) { 
        var _xx = _start_x + (i * 40); 
        var _val = global.hp - (i * 2);
        var _index = 0;
        
        if (_val >= 2) _index = 0;      // Lleno
        else if (_val == 1) _index = 1; // Medio
        else _index = 2;               // Vacio
        
        draw_sprite_ext(spr_icon_heart, _index, _xx, _start_y, 1.2, 1.2, 0, c_white, 1);
    }

    // Municion
    var _ammo_start_x = 110;
    var _ammo_start_y = 110; 

    for (var i = 0; i < 5; i++) { 
        var _xx = _ammo_start_x + (i * 15); 
        
        var _val = global.ammo - (i * 2);
      
        var _index = 2; // vacio
        if (_val >= 2)      _index = 0; // Lleno
        else if (_val == 1) _index = 1; // Medio

        draw_sprite_ext(spr_stamina_segment, _index, _xx, _ammo_start_y, 1.7, 1.7, 0, c_white, 1);
    }

    draw_sprite_ext(spr_diamante, 0, 230, 120, 3.5, 3.5, 0, c_white, 1); 
    
    draw_set_font(fnt_small); 
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text(255, 120, string(global.coins));
}
else if (os_type == os_android || os_type == os_ios) 
{
    draw_sprite_ext(spr_portrait_face, 0, 30, 60, 1.5, 1.5, 0, c_white, 1); 

    var _start_x = 135; 
    var _start_y = 65; 

    for (var i = 0; i < 3; i++) { 
        var _xx = _start_x + (i * 40); 
        var _val = global.hp - (i * 2);
        var _index = 0;
        
        if (_val >= 2) _index = 0;      // Lleno
        else if (_val == 1) _index = 1; // Medio
        else _index = 2;               // Vacio
        
        draw_sprite_ext(spr_icon_heart, _index, _xx, _start_y, 1.5, 1.5, 0, c_white, 1);
    }

    // Municion
    var _ammo_start_x = 130;
    var _ammo_start_y = 115; 

    for (var i = 0; i < 5; i++) { 
        var _xx = _ammo_start_x + (i * 15); 
        
        var _val = global.ammo - (i * 2);
      
        var _index = 2; // vacio
        if (_val >= 2)      _index = 0; // Lleno
        else if (_val == 1) _index = 1; // Medio

        draw_sprite_ext(spr_stamina_segment, _index, _xx, _ammo_start_y, 2, 2, 0, c_white, 1);
    }	

    draw_sprite_ext(spr_diamante, 0, 130, 250, 2.5,2.5, 0, c_white, 1); 
    
    draw_set_font(fnt_small);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text(155, 250, string(global.coins));
}