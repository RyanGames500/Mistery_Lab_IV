enum ESTADO_DRYAD { INACTIVA, CARGANDO, ATACANDO, RECUPERANDO }

estado = ESTADO_DRYAD.INACTIVA;
timer = 0;
vsp = 0;
grav = 0.3;
dir = 1;

rango_ataque = 280;
raices_creadas = 0;
raices_max = 12;       // cuántos tramos de raíz salen
separacion = 24;       // distancia entre tramos (px)
intervalo_raiz = 5;    // frames entre cada tramo (velocidad de la ola)
stun_timer = 0;
hp = 30;            // ajusta por enemigo (Avatar 60, Dryad 20, etc.)
hit_next = 0;       // evita que un solo golpe le pegue varias veces