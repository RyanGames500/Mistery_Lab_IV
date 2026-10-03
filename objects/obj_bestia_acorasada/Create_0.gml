enum ESTADO_BESTIA { PATRULLA, ALERTA, EMBESTIDA, REPOSO }

estado = ESTADO_BESTIA.PATRULLA;
hsp = 0;
vsp = 0;
grav = 0.4;
timer = 0;
cooldown_ataque = 60;

// Patrulla (muy lenta)
dir_patrulla = 1;
vel_patrulla = 0.6;
limite_patrulla = 80;
pausa = 0;
pausa_extremo = 60;

// Embestida
rango_vision = 280;
tiempo_alerta = 50;               // aviso antes de correr
vel_embestida = 6;
embestida_max = 90;               // frames máximos corriendo
tiempo_recuperacion_carga = 100;  // aturdida si choca con una pared
tiempo_derrape = 30;              // cansada si frena sin chocar

// Vida y efectos (muy resistente)
hp = 120;
hit_next = 0;
stun_timer = 0;
miel_timer = 0;