if (!activo) exit;

if (!slideshow_mode) {
    // Navegación Manual
    if (keyboard_check_pressed(vk_right)) {
        selected_index = (selected_index + 1) % array_length(items);
    }
    if (keyboard_check_pressed(vk_left)) {
        selected_index = (selected_index - 1 + array_length(items)) % array_length(items);
    }
    
    // Iniciar Presentación
    if (keyboard_check_pressed(ord("S"))) {
        slideshow_mode = true;
        slideshow_timer = 0;
    }
    
    // Salir (Cerrar)
    if (keyboard_check_pressed(vk_escape)) {
        activo = false;
        instance_activate_all();
    }
} else {
    // Modo Slideshow Automático
    slideshow_timer++;
    if (slideshow_timer >= slideshow_speed) {
        selected_index = (selected_index + 1) % array_length(items);
        slideshow_timer = 0;
    }
    
    // Salir del modo presentación (Cualquier tecla)
    if (keyboard_check_pressed(vk_anykey)) {
        slideshow_mode = false;
    }
}