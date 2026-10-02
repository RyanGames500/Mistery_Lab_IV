enum ESTADO_AVATAR { ACECHANDO, AVISO_CARGA, CARGANDO, AVISO_SALTO, SALTANDO, RECUPERANDO }

estado = ESTADO_AVATAR.ACECHANDO;
timer = 60;
hsp = 0;
vsp = 0;
grav = 0.4;
dir = -1;

// Distancias que deciden el patrón
rango_deteccion = 450;
dist_cerca = 140;       // menos que esto -> salto
dist_lejos = 300;       // más que esto -> carga
ultimo_ataque = 0;      // 0 = carga, 1 = salto (para alternar en distancia media)

// Carga
carga_vel = 7;
carga_duracion = 60;    // frames máximos corriendo

// Salto
salto_fuerza = 9;
salto_vel_max = 6;

// Banderas de colisión
choco_pared = false;
aterrizo = false;

stun_timer = 0;

hp = 30;            // ajusta por enemigo (Avatar 60, Dryad 20, etc.)
hit_next = 0;       // evita que un solo golpe le pegue varias veces