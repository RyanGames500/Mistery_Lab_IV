function completar_nivel_actual() {
    var _m = global.mundo_activo;
    var _n = global.nivel_activo; 

    if (_n + 1 < array_length(global.mundos[_m].niveles)) {
        global.mundos[_m].niveles[_n + 1].unlocked = true;
    } else {
        if (_m + 1 < array_length(global.mundos)) {
            global.mundos[_m + 1].unlocked = true;
            global.mundos[_m + 1].niveles[0].unlocked = true;
        }
    }

    guardar_progreso_niveles();
}