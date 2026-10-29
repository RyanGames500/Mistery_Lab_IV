// ===== AJUSTES: apaga =====
#macro FX_INTENSIDAD     1.0    // 0.5 suave ... 1.5 fuerte
#macro FX_HITSTOP        true   // congela el juego un instante al impactar
#macro FX_FLASH          true
#macro FX_TEMBLOR        true
#macro FX_ZOOM           true
#macro FX_ONDAS          true
#macro FX_CHISPAS        true
#macro FX_SLOWMO         true
#macro FX_FONDO_OSCURO   true
#macro FX_NOMBRE         false
#macro FX_HITSTOP_FPS    8      // velocidad del juego durante el congelado
#macro FX_SLOWMO_FPS     30     // velocidad en cámara lenta
#macro FX_SLOWMO_STEPS   20     // cuántos steps dura la cámara lenta
#macro FX_TEXTO_ESCALA   3

// Colores y nombre de cada forma
function fx_datos_forma(_tipo) {
    switch (_tipo) {
        case 8:  return { nombre: "NINFA",  c1: make_color_rgb(255, 208, 230), c2: make_color_rgb(255, 95, 162) };
        case 9:  return { nombre: "AVION",  c1: make_color_rgb(166, 236, 98),  c2: make_color_rgb(47, 179, 122) };
        case 10: return { nombre: "MEDUSA", c1: make_color_rgb(82, 220, 255),  c2: make_color_rgb(122, 92, 255) };
        case 11: return { nombre: "HADA",   c1: make_color_rgb(255, 122, 217), c2: make_color_rgb(181, 139, 255) };
        case 12: return { nombre: "ARPIA",  c1: make_color_rgb(255, 162, 58),  c2: make_color_rgb(214, 74, 42) };
    }
    return { nombre: "", c1: c_white, c2: c_aqua };
}

// Suelta chispas desde la posición del objeto de efecto (se llama desde dentro de él)
function fx_chispas(_n) {
    for (var i = 0; i < _n; i++) {
        var _a = random(360);
        var _v = (2 + random(5)) * k;
        sparks[array_length(sparks)] = {
            x: x, y: y,
            vx: lengthdir_x(_v, _a),
            vy: lengthdir_y(_v, _a) - 1.2,
            t: 0, life: 30 + random(22), s: 2 + random(2.5),
            c: (i % 3 == 0) ? c_white : ((i % 2 == 0) ? c1 : c2)
        };
    }
}

// Se llama UNA vez cuando un enemigo transforma a Gaby
function fx_transformacion(_x, _y, _tipo) {
    if (instance_exists(obj_fx_transformacion)) exit;

    var _fx = instance_create_depth(_x, _y - 50, -10000, obj_fx_transformacion);
    with (_fx) {
        tipo = _tipo;
        var _d = fx_datos_forma(_tipo);
        nombre = _d.nombre;
        c1 = _d.c1;
        c2 = _d.c2;
        k = FX_INTENSIDAD;

        if (FX_FLASH)  { flash_len = 10; flash = 10; flash_max = min(1, 0.85 * k); }
        if (FX_ONDAS) {
            rings[array_length(rings)] = { delay: 0, t: 0, life: 24, r1: 110 * k };
            rings[array_length(rings)] = { delay: 5, t: 0, life: 24, r1: 80 * k };
        }
        if (FX_CHISPAS)      fx_chispas(round(32 * k));
        if (FX_FONDO_OSCURO) dim_t = dim_len;
        if (FX_NOMBRE)       popup_delay = 6;
        if (FX_HITSTOP)      game_set_speed(FX_HITSTOP_FPS, gamespeed_fps);

        alarm[0] = 1;   // al siguiente step termina el congelado
    }

    if (FX_TEMBLOR) screen_shake(9 * FX_INTENSIDAD);
    if (FX_ZOOM && instance_exists(obj_camera)) {
        with (obj_camera) zoom_actual += 0.16 * FX_INTENSIDAD;
    }
}