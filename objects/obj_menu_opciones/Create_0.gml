activo = false;
selected = 0;


ini_open("config.ini");
global.volumen = ini_read_real("audio", "volumen", 100);
global.shaders_activos = ini_read_real("graficos", "shaders", 1);
global.idioma_actual = ini_read_string("juego", "idioma", "en");
ini_close();