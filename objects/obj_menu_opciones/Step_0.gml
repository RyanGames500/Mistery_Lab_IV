if (!activo) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _touch = device_mouse_check_button_pressed(0, mb_left);

// Navegación Vertical
if (keyboard_check_pressed(vk_down)) {
    selected = (selected + 1) % 4;
}
if (keyboard_check_pressed(vk_up)) {
    selected = (selected - 1 + 4) % 4;
}

// Navegación Horizontal Limpia (Para que las flechas no se traben)
if (selected == 0) {
    if (keyboard_check_pressed(vk_right)) {
        global.volumen = clamp(global.volumen + 10, 0, 100);
        audio_master_gain(global.volumen / 100);
    }
    if (keyboard_check_pressed(vk_left)) {
        global.volumen = clamp(global.volumen - 10, 0, 100);
        audio_master_gain(global.volumen / 100);
    }
}
else if (selected == 1 && (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_left))) {
    global.shaders_activos = !global.shaders_activos;
}
else if (selected == 2 && (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_left))) {
    global.idioma_actual = (global.idioma_actual == "en") ? "es" : "en";
    cargar_idioma("lang_" + global.idioma_actual + ".json");
}

// SALIR CON TECLADO
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("Z"))) {
    if (selected == 3) {
        ini_open("config.ini");
        ini_write_real("audio", "volumen", global.volumen);
        ini_write_real("graficos", "shaders", global.shaders_activos);
        ini_write_string("juego", "idioma", global.idioma_actual);
        ini_close();
        
        selected = 0;
        activo = false;
        visible = false;
        
        // El Combo Salvador:
        global.pausado = false; 
        instance_activate_all(); // Recuperamos las paredes y el control
        io_clear(); // MAGIA: Limpia el teclado para que el jugador no vuelva a leer la Z
    }
}

// SALIR CON TÁCTIL
var _y_base = _gui_h / 2 - 100;
for (var i = 0; i < 4; i++) {
    var _btn_y = _y_base + (i * 60);
    if (point_in_rectangle(_mx, _my, _gui_w/2 - 250, _btn_y - 20, _gui_w/2 + 250, _btn_y + 30)) {
        selected = i;
        if (_touch) {
            if (i == 0) {
                global.volumen = (global.volumen >= 100) ? 0 : global.volumen + 25;
                audio_master_gain(global.volumen / 100);
            }
            else if (i == 1) {
                global.shaders_activos = !global.shaders_activos;
            }
            else if (i == 2) {
                global.idioma_actual = (global.idioma_actual == "en") ? "es" : "en";
                cargar_idioma("lang_" + global.idioma_actual + ".json");
            }
            else if (i == 3) {
                ini_open("config.ini");
                ini_write_real("audio", "volumen", global.volumen);
                ini_write_real("graficos", "shaders", global.shaders_activos);
                ini_write_string("juego", "idioma", global.idioma_actual);
                ini_close();
                
                selected = 0;
                activo = false;
                visible = false;
                
                global.pausado = false;
                instance_activate_all();
                io_clear(); // Limpia clics fantasma
            }
        }
    }
}