enum ESTADO_ANGEL { FLOTANDO, CARGANDO, DISPARANDO, CAMBIANDO_ALTURA }

estado = ESTADO_ANGEL.FLOTANDO;
timer = 60;
dir = -1;

// Flotación
y_base = y;                 // altura actual "de referencia"
y_suelo = y;                // altura de origen
altura_objetivo = y;
t_flotar = 0;
alturas = [0, -48, -96];    // offsets de altura posibles (ajusta a tu nivel)

// Ataque
rango_ataque = 320;
rango_vertical = 200;
rondas_totales = 2;
rondas_hechas = 0;
patron = 0;                 // alterna el patrón de ángulos
vel_fragmento = 4;

stun_timer = 0;
hp = 30;            // ajusta por enemigo (Avatar 60, Dryad 20, etc.)
hit_next = 0;       // evita que un solo golpe le pegue varias veces