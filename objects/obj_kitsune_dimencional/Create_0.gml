enum ESTADO_KITSUNE { ESPERA, TELEPORT, REAPARECER, PREPARAR_EMBESTIDA, EMBESTIDA, RECUPERACION }

estado = ESTADO_KITSUNE.ESPERA;
timer_estado = 30;
hsp = 0;
vsp = 0;
grav = 0.4;
dir_embestida = 1;

rango_vision = 350;
vel_embestida = 9;

// Agilidad
tps_min = 1;              // mínimo de teleports por combo
tps_max = 3;              // máximo de teleports por combo
tps_restantes = 0;
dist_tp_min = 70;         // distancia mínima a Gaby al reaparecer
dist_tp_max = 170;        // distancia máxima
espera_tiempo = 25;       // pausa corta entre combos
prob_encadenar = 0.4;     // probabilidad de repetir combo sin descansar

stun_timer = 0;
miel_timer = 0;
hp = 30;            // ajusta por enemigo (Avatar 60, Dryad 20, etc.)
hit_next = 0;       // evita que un solo golpe le pegue varias veces