enum ESTADO_SLIME { REBOTANDO, AGACHADA, SALTO_LARGO }

estado = ESTADO_SLIME.REBOTANDO;
hsp = 0;
vsp = 0;
grav = 0.4;
dir = 1;
timer = 0;

// Rebotes chicos (en el lugar)
vel_salto_rebote = -5;
rebotes = 0;
rebotes_para_salto = irandom_range(2, 4);

// Salto largo horizontal
rango_vision = 300;
tiempo_aviso = 28;       // agachada antes de saltar
salto_vsp = -5.5;        // arco bajo y largo
salto_hsp_min = 3;
salto_hsp_max = 6;
objetivo_x = x;

// Visual (squash & stretch)
esc_y = 1;

// Vida y efectos (conserva tus valores si ya los tenías)
hp = 30;
hit_next = 0;
stun_timer = 0;
miel_timer = 0;