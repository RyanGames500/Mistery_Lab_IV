if (place_meeting(x, y, obj_jugador)) {
    if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up)) {
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
        else if (target_room != noone) {
            room_goto(target_room);
        } 
        
    }
}