
with (obj_jugador) {
    if (place_meeting(x, y, other)) {
        // Empuje normal
        vsp -= 0.5;

        if (is_transformed && transform_type == 1) {
            vsp -= 0.5; 
        }
    }
}