var oPlayer = obj_jugador;

// --- CONTROL DE EFECTOS GLOBALES (Stun / Miel) ---
if (stun_timer > 0) {
    stun_timer--;
    hsp = 0;
    vsp = 0;
    exit;
}

if (miel_timer > 0) {
    miel_timer--;
    hsp *= 0.5;
}

// Gravedad
if (!place_meeting(x, y + 1, obj_wall)) {
    vsp += grav;
} else {
    vsp = 0;
}

// --- MÁQUINA DE ESTADOS ---
switch (estado) {

    case ESTADO_KITSUNE.ESPERA:
        hsp = 0;
        image_alpha = 1;
        image_blend = c_white;

        if (instance_exists(oPlayer)) {
            image_xscale = (oPlayer.x > x) ? 1 : -1;
        }

        if (timer_estado > 0) {
            timer_estado--;
        } else if (instance_exists(oPlayer)) {
            if (abs(x - oPlayer.x) <= rango_vision) {
                tps_restantes = irandom_range(tps_min, tps_max);
                estado = ESTADO_KITSUNE.TELEPORT;
                timer_estado = 8; // se desvanece rápido
            }
        }
        break;

    case ESTADO_KITSUNE.TELEPORT:
        hsp = 0;
        vsp = 0;

        if (timer_estado > 0) {
            timer_estado--;
            image_alpha = max(0.15, timer_estado / 8); // se desvanece
        } else if (instance_exists(oPlayer)) {

            // Buscar una posición válida alrededor de Gaby
            var _encontrada = false;
            var _px = x;
            var _py = y;

            repeat (12) {
                var _lado = choose(-1, 1);
                var _d = irandom_range(dist_tp_min, dist_tp_max);
                var _nx = oPlayer.x + _lado * _d;
                var _ny = oPlayer.y - 32;

                // Dentro del mapa y no dentro de una pared
                if (_nx < 16 || _nx > room_width - 16) continue;
                if (place_meeting(_nx, _ny, obj_wall)) continue;

                // Bajar hasta encontrar suelo
                var _pasos = 0;
                while (!place_meeting(_nx, _ny + 1, obj_wall) && _pasos < 96) {
                    _ny++;
                    _pasos++;
                }
                if (_pasos >= 96) continue; // no hay suelo, vacío

                // Que no reaparezca casi en el mismo lugar
                if (abs(_nx - x) < 40) continue;

                _px = _nx;
                _py = _ny;
                _encontrada = true;
                break;
            }

            if (_encontrada) {
                x = _px;
                y = _py;
            }

            image_alpha = 1;
            image_xscale = (oPlayer.x > x) ? 1 : -1;
            tps_restantes--;

            if (tps_restantes > 0) {
                // Aparece un instante y vuelve a desaparecer
                estado = ESTADO_KITSUNE.REAPARECER;
                timer_estado = irandom_range(8, 14);
            } else {
                // Último teleport: prepara la embestida
                estado = ESTADO_KITSUNE.PREPARAR_EMBESTIDA;
                timer_estado = 14;
            }
        }
        break;

    case ESTADO_KITSUNE.REAPARECER:
        hsp = 0;
        image_alpha = 1;

        if (instance_exists(oPlayer)) {
            image_xscale = (oPlayer.x > x) ? 1 : -1;
        }

        if (timer_estado > 0) {
            timer_estado--;
        } else {
            estado = ESTADO_KITSUNE.TELEPORT;
            timer_estado = 6;
        }
        break;

    case ESTADO_KITSUNE.PREPARAR_EMBESTIDA:
        hsp = 0;
        image_alpha = 1;

        // Parpadeo de aviso
        image_blend = (timer_estado mod 4 < 2) ? c_white : make_color_rgb(255, 160, 90);

        // Sigue mirando a Gaby hasta el último momento
        if (instance_exists(oPlayer)) {
            image_xscale = (oPlayer.x > x) ? 1 : -1;
        }

        if (timer_estado > 0) {
            timer_estado--;
        } else {
            // La dirección se decide AHORA, no antes
            if (instance_exists(oPlayer)) {
                dir_embestida = (oPlayer.x > x) ? 1 : -1;
            } else {
                dir_embestida = image_xscale;
            }
            image_xscale = dir_embestida;
            image_blend = c_white;

            estado = ESTADO_KITSUNE.EMBESTIDA;
            timer_estado = 22;
        }
        break;

    case ESTADO_KITSUNE.EMBESTIDA:
        hsp = dir_embestida * vel_embestida;
        timer_estado--;

        var _pared = place_meeting(x + hsp, y, obj_wall);

        if (timer_estado <= 0 || _pared) {
            if (_pared && script_exists(asset_get_index("screen_shake"))) {
                screen_shake(3);
            }
            estado = ESTADO_KITSUNE.RECUPERACION;
            timer_estado = 35; // ventana de castigo más corta
        }
        break;

    case ESTADO_KITSUNE.RECUPERACION:
        hsp = 0;
        image_alpha = 1;

        if (timer_estado > 0) {
            timer_estado--;
        } else {
            if (instance_exists(oPlayer) && random(1) < prob_encadenar
                && abs(x - oPlayer.x) <= rango_vision) {
                // Encadena otro combo sin descansar
                tps_restantes = irandom_range(1, 2);
                estado = ESTADO_KITSUNE.TELEPORT;
                timer_estado = 8;
            } else {
                estado = ESTADO_KITSUNE.ESPERA;
                timer_estado = espera_tiempo;
            }
        }
        break;
}

// --- COLISIONES HORIZONTALES ---
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

// --- COLISIONES VERTICALES ---
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;

// --- DAÑO A GABY (solo mientras está visible y atacando) ---
if (estado == ESTADO_KITSUNE.EMBESTIDA) {
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
                hsp = _dir_empuje * 5;
                vsp = -3;
            }
        }
    }
}