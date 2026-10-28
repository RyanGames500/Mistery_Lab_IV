enum ESTADO_IMAN { ESPERA, AVISO, ACTIVO, SOBRECARGA }

estado = ESTADO_IMAN.ESPERA;
timer = 90;                  // primer ciclo

// Campo magnético
rango_vision = 220;          // alcance horizontal del campo
alto_campo = 64;             // alto del campo (arriba y abajo)
fuerza_min = 1.2;            // tirón en el borde del campo
fuerza_max = 2.4;            // tirón pegado a ella
distancia_nucleo = 24;       // no arrastra a Gaby más cerca que esto

// Tiempos (a 60 fps)
tiempo_espera = 150;
tiempo_aviso = 45;
tiempo_activo = 80;
tiempo_sobrecarga = 40;

golpeo_gaby = false;

// Vida y efectos
hp = 40;
hit_next = 0;
stun_timer = 0;