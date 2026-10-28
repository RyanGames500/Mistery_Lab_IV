cam_width = 480;
cam_height = 270;

// Posición base de la cámara (sin shake)
cam_x = 0;
cam_y = 0;
iniciada = false;
room_anterior = room;

// Suavizado
spd_x = 0.12;
spd_y = 0.08;       // reacomodo vertical en el suelo
spd_borde = 0.25;   // seguimiento rápido en el aire si sale de la ventana

// Look ahead
look_ahead = 0;
look_dist = 40;
facing = 1;

// Vertical
piso_pantalla = 0.6;   // en el suelo, Gaby queda al 60% de la altura
borde_arriba = 0.2;    // en el aire, si sube de aquí la cámara la sigue
borde_abajo = 0.75;    // si cae más abajo de aquí la cámara la sigue
suelo_timer = 0;

// Shake
shake_amount = 0;
shake_friction = 0.9;

// --- Cinemáticas ---
if (!variable_global_exists("cinematica")) global.cinematica = false;

zoom_actual = 1;
cine_activa = false;
cine_x = 0;
cine_y = 0;
cine_zoom = 1.8;      // 1 = normal, más alto = más cerca
cine_timer = 0;
cine_total = 1;
cine_spd = 0.06;
cine_titulo = "";
barras = 0;

iniciar_cine = function(_x, _y, _zoom, _frames, _titulo = "") {
    cine_activa = true;
    cine_x = _x;
    cine_y = _y;
    cine_zoom = _zoom;
    cine_total = _frames;
    cine_timer = _frames;
    cine_titulo = _titulo;
    global.cinematica = true;
};