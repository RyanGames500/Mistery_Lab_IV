function cargar_progreso_niveles() {
    // Si el archivo de guardado no existe todavía, salimos de la función sin dar error
    if (!file_exists("save.ini")) {
        exit;
    }
    
    ini_open("save.ini");
    
    for (var m = 0; m < array_length(global.mundos); m++) {
        var _mundo = global.mundos[m];
        
        var _def_mundo = (m == 0 ? 1 : 0);
        _mundo.unlocked = ini_read_real("Mundos", "mundo_" + string(m), _def_mundo);
        
        for (var n = 0; n < array_length(_mundo.niveles); n++) {
            var _nivel = _mundo.niveles[n];
            
            var _def_nivel = (m == 0 && n == 0 ? 1 : 0);
            _nivel.unlocked = ini_read_real("Niveles_M" + string(m), "nivel_" + string(n), _def_nivel);
        }
    }
    
    ini_close();
    
    ini_open("config.ini");
    global.volumen = ini_read_real("audio", "volumen", 100);
    audio_master_gain(global.volumen / 100);
    global.shaders_activos = ini_read_real("graficos", "shaders", 1);
    global.idioma_actual = ini_read_string("juego", "idioma", "en");
    cargar_idioma("lang_" + global.idioma_actual + ".json");
    
    ini_close();
}