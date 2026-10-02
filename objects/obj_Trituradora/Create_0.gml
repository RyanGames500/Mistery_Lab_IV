enum ESTADO_TRITURADORA { ESPERA, PREPARACION, GOLPE, RECUPERACION }
estado = ESTADO_TRITURADORA.ESPERA;
cooldown_ciclo = 0;

tiempo_espera = 90;
tiempo_golpe = 30;
fuerza_impacto = 6;
y_original = y;
y_destino = y + 48;
hp = 30;            // ajusta por enemigo (Avatar 60, Dryad 20, etc.)
hit_next = 0;       // evita que un solo golpe le pegue varias veces