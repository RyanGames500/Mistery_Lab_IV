function cargar_idioma(_nombre_archivo) {
    if (file_exists(_nombre_archivo)) {
        var _buffer = buffer_load(_nombre_archivo);
        var _string = buffer_read(_buffer, buffer_string);
        buffer_delete(_buffer);
        global.lang = json_parse(_string);
        show_debug_message("Idioma cargado correctamente: " + _nombre_archivo);
    } else {
        show_debug_message("¡ERROR! No se encontró el archivo: " + _nombre_archivo);
        // Creamos un diccionario vacío para que el juego no crashee
        global.lang = {}; 
    }
}

function tr(_key) {
    // Si global.lang existe y tiene la llave, la devuelve
    if (variable_global_exists("lang") && variable_struct_exists(global.lang, _key)) {
        return global.lang[$ _key];
    }
    // Si no, devuelve el error para que veamos qué falta
    return "MISSING: " + _key;
}