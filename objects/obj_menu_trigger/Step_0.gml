if (place_meeting(x, y, obj_jugador)) {
    if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(ord("X"))) {
        //if (titulo == "Galeria") {
            //with (obj_galeria) {
                //activo = true;
                //instance_deactivate_all(true);
                //instance_activate_object(id);
            //}
        //}
        if (titulo == "Tienda") {
            with (obj_tienda) {
                activo = true;
                instance_deactivate_all(true);
                instance_activate_object(id);
            }
        }
        if (titulo == "Opciones") {
            global.pausado = true;
           with (obj_menu_opciones) {
                   activo = true;
                   visible = true;
                   selected = 0;
               }
               io_clear(); // Evitamos que el menú lea la Z de inmediato y se cierre
        }            
        else if (target_room != noone) {
            room_goto(target_room);
        } 
        
    }
}