enum ESTADO_NINFA {
    INACTIVA,
    DESAPARECER,
    TELETRANSPORTAR,
    CAER,
    SUBIR_TRAS_GOLPE,
    ESPERA_TRANSFORMACION
}

estado = ESTADO_NINFA.INACTIVA;

rango_deteccion = 150;
timer_ataque = 0;
intervalo_ataque = 180;
duracion_desvanecer = 0;
velocidad_caida = 10;
impacto_suelo = false;