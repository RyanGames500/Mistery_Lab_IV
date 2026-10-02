enum ESTADO_GUARDIANA { PATRULLA, AVISO, DISPARO }

estado = ESTADO_GUARDIANA.PATRULLA;
hsp = 0;
vsp = 0;
grav = 0.4;
timer = 0;

// Patrulla
dir_patrulla = 1;
vel_patrulla = 1.2;
limite_patrulla = 96;
pausa = 0;
pausa_extremo = 30;      // se detiene un momento al dar la vuelta

// Ataque
rango_vision = 260;
tiempo_aviso = 25;       // advertencia antes de disparar
tiempo_retroceso = 20;   // pausa después de disparar
cooldown_ataque = 60;
cooldown_disparo = 120;
tiro_alto = false;       // alterna entre tiro bajo y alto

stun_timer = 0;
miel_timer = 0;
hp = 30;            // ajusta por enemigo (Avatar 60, Dryad 20, etc.)
hit_next = 0;       // evita que un solo golpe le pegue varias veces