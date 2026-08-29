enum ESTADO_ARP {
    PATRULLA,
    PICADA,
    REGRESO_CIELO,
    REGRESO_CASA,
    ESPERA
}
estado = ESTADO_ARP.PATRULLA;
hsp = 0;
vsp = 0;
vel_patrulla = 1.5;
rango_vision = 200;
limite_patrulla = 150; 
dir_patrulla = 1;
objetivo_x = 0;
objetivo_y = 0;
vel_picada_h = 0;
vel_picada_v = 0;
altura_patrulla_y = y;
cooldown_ataque = 0;
tiempo_espera_max = 120;