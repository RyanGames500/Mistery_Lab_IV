enum ESTADO_BESTIA { PATRULLA, ALERTA, EMBESTIDA, REPOSO }
estado = ESTADO_BESTIA.PATRULLA;
hsp = 0;
vsp = 0;
grav = 0.3;

// Configuración de movimiento y combate
vel_patrulla = 1;         // Muy lenta caminando
vel_embestida = 4.5;      // Corre pesado cuando ve a Gaby
rango_vision = 220;       // Distancia horizontal a la que detecta a Gaby
limite_patrulla = 150;    // Distancia máxima de su zona de patrulla desde xstart

cooldown_ataque = 0;
tiempo_recuperacion_carga = 90; // Tiempo que se queda cansada/fija si choca contra un muro
dir_patrulla = 1;

hp = 30;            // ajusta por enemigo (Avatar 60, Dryad 20, etc.)
hit_next = 0;       // evita que un solo golpe le pegue varias veces