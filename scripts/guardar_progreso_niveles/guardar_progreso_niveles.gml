function guardar_progreso_niveles() {
    ini_open("save.ini");
    
    for (var m = 0; m < array_length(global.mundos); m++) {
        var _mundo = global.mundos[m];
        ini_write_real("Mundos", "mundo_" + string(m), _mundo.unlocked);
        
        for (var n = 0; n < array_length(_mundo.niveles); n++) {
            var _nivel = _mundo.niveles[n];
            ini_write_real("Niveles_M" + string(m), "nivel_" + string(n), _nivel.unlocked);
        }
    }
    
    ini_close();
}