var oPlayer = obj_jugador;

// Stun / miel
if (stun_timer > 0) { stun_timer--; exit; }

if (timer > 0) timer--;
choco_pared = false;
aterrizo = false;

// --- FÍSICA ---
vsp += grav;

// Horizontal
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) x += sign(hsp);
    hsp = 0;
    choco_pared = true;
}
x += hsp;

// Vertical
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) y += sign(vsp);
    if (vsp > 0) aterrizo = true;
    vsp = 0;
}
y += vsp;

// --- MÁQUINA DE ESTADOS ---
switch (estado) {

    case ESTADO_AVATAR.ACECHANDO:
        hsp = 0;
        if (instance_exists(oPlayer)) {
            dir = (oPlayer.x > x) ? 1 : -1;
            image_xscale = dir;

            var _dist = abs(x - oPlayer.x);

            if (timer <= 0 && _dist <= rango_deteccion && abs(y - oPlayer.y) < 64) {
                var _elige_carga;

                if (_dist >= dist_lejos)      _elige_carga = true;    // lejos -> carga
                else if (_dist <= dist_cerca) _elige_carga = false;   // cerca -> salto
                else _elige_carga = (ultimo_ataque == 1);             // medio -> alterna

                if (_elige_carga) {
                    estado = ESTADO_AVATAR.AVISO_CARGA;
                    timer = 30;
                    ultimo_ataque = 0;
                } else {
                    estado = ESTADO_AVATAR.AVISO_SALTO;
                    timer = 25;
                    ultimo_ataque = 1;
                }
            }
        }
        break;

    case ESTADO_AVATAR.AVISO_CARGA:
        hsp = 0;
        // Aquí pones animación/brillo de que va a cargar
        if (timer <= 0) {
            estado = ESTADO_AVATAR.CARGANDO;
            timer = carga_duracion;
            hsp = dir * carga_vel;
        }
        break;

    case ESTADO_AVATAR.CARGANDO:
        hsp = dir * carga_vel;

        // Se detiene si choca con pared, se acaba el tiempo o se acaba el suelo
        var _sin_suelo = !place_meeting(x + dir * 24, y + 1, obj_wall);
        if (choco_pared || _sin_suelo || timer <= 0) {
            hsp = 0;
            estado = ESTADO_AVATAR.RECUPERANDO;
            timer = choco_pared ? 80 : 50; // si choca con la pared queda más aturdida
        }
        break;

    case ESTADO_AVATAR.AVISO_SALTO:
        hsp = 0;
        // Aquí pones animación de agacharse
        if (timer <= 0) {
            vsp = -salto_fuerza;

            // Calcula la velocidad horizontal para caer cerca de Gaby
            var _t_aire = (2 * salto_fuerza) / grav;
            var _objetivo = instance_exists(oPlayer) ? oPlayer.x : x + dir * 100;
            hsp = clamp((_objetivo - x) / _t_aire, -salto_vel_max, salto_vel_max);

            estado = ESTADO_AVATAR.SALTANDO;
        }
        break;

    case ESTADO_AVATAR.SALTANDO:
        if (aterrizo) {
            hsp = 0;

            // Impacto: dos ondas viajando por el suelo, una a cada lado
            for (var i = -1; i <= 1; i += 2) {
                var _o = instance_create_layer(x + i * 20, bbox_bottom, layer, obj_onda_impacto);
                _o.hsp = i * 5;
            }

            estado = ESTADO_AVATAR.RECUPERANDO;
            timer = 70;
        }
        break;

    case ESTADO_AVATAR.RECUPERANDO:
        hsp = 0;
        if (timer <= 0) {
            estado = ESTADO_AVATAR.ACECHANDO;
            timer = 45; // cooldown
        }
        break;
}

// --- DAÑO POR CONTACTO (solo mientras ataca) ---
if (estado == ESTADO_AVATAR.CARGANDO || estado == ESTADO_AVATAR.SALTANDO) {
    if (instance_exists(oPlayer) && place_meeting(x, y, oPlayer)) {
        with (oPlayer) {
            if (!is_dead && !is_transforming && !invincible) {
                player_take_damage(1, false, 1);
                if (global.hp <= 0) {
                    is_dead = true;
                }
                invincible = true;
                alarm[2] = 90;

                var _dir_empuje = sign(x - other.x);
                if (_dir_empuje == 0) _dir_empuje = 1;
                hsp = _dir_empuje * 4;
                vsp = -3;
            }
        }
    }
}