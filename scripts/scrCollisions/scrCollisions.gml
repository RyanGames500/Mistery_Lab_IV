function scrCollisions(){
    // Definimos qué objetos cuentan como suelo/pared para el jugador
    // (Puedes meter aquí tus tipos de plataformas si no usan un objeto padre)
    
    // 1. COLISIÓN HORIZONTAL
    if (place_meeting(x + hsp, y, obj_wall) || place_meeting(x + hsp, y, obj_hielo))
    {
        while(!place_meeting(x + sign(hsp), y, obj_wall) && !place_meeting(x + sign(hsp), y, obj_hielo)) {
            x += sign(hsp);
        }
        hsp = 0;
    }
    x += hsp;

    // 2. COLISIÓN VERTICAL (Muros, Hielo y Plataformas)
    var _col_vertical = place_meeting(x, y + vsp, obj_wall) || 
                        place_meeting(x, y + vsp, obj_hielo) || 
                        place_meeting(x, y + vsp, obj_plataforma_movil) || 
                        place_meeting(x, y + vsp, obj_plataforma_caida) || 
                        place_meeting(x, y + vsp, obj_plataforma_atravesable);

    if (_col_vertical) 
    {
        while(!place_meeting(x, y + sign(vsp), obj_wall) && 
              !place_meeting(x, y + sign(vsp), obj_hielo) && 
              !place_meeting(x, y + sign(vsp), obj_plataforma_movil) && 
              !place_meeting(x, y + sign(vsp), obj_plataforma_caida) && 
              !place_meeting(x, y + sign(vsp), obj_plataforma_atravesable))      
        {
            y += sign(vsp);
        }
    
        // Si es la pelota y va cayendo, respetamos su rebote en lugar de anularlo de golpe
        if (is_transformed && transform_type == 1 && vsp > 0) {
            vsp = -vsp * bounce_factor;
            if (abs(vsp) < 2) vsp = 0;
        } else {
            vsp = 0;
        }
    }
    
    // 3. COMPROBACIÓN DE SUELO GENERAL
    if (place_meeting(x, y + 1, obj_wall) || place_meeting(x, y + 1, obj_hielo) || place_meeting(x, y + 1, obj_plataforma_movil))  
    {
        landed = true;
    }
    else
    {
        landed = false;    
    }

    y += vsp;
}