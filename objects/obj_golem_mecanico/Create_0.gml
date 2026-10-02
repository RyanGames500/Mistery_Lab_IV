// Enum de Estados para el Golem Mecánico (En suelo)
enum ESTADO_GOLEM {
    PATRULLA,
    ALERTA,     // Pausa breve antes de arrancar la carga
    CARGA,      // Corre veloz en línea recta hacia donde vio a Gaby
    CHOKE,      // Se estrella contra una pared y se queda aturdido un momento
    REGRESO     // Vuelve a su zona inicial o patrulla normal
}

estado = ESTADO_GOLEM.PATRULLA;

// Variables de movimiento y físicas
hsp = 0;
vsp = 0;
grav = 0.3;          // Gravedad para el suelo
vel_patrulla = 1.2;  // Caminata lenta
vel_carga = 5.5;     // Velocidad rápida de la embestida

// Límites y detección
rango_vision = 220;  // Distancia horizontal para detectar a Gaby
limite_patrulla = 120; 
dir_patrulla = 1;
objetivo_x = 0;

cooldown_ataque = 0;
tiempo_espera_max = 90; // Tiempo de descanso tras cargar
tiempo_choke = 60;      // Frames que se queda aturdida si choca contra la pared