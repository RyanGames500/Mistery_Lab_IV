var oPlayer = obj_jugador;

if (global.cinematica) exit;

// --- STUN ---
if (stun_timer > 0) {
    stun_timer--;
    exit;
}

if (timer > 0) timer--;

// --- ¿Gaby está dentro del campo y sin pared en medio? ---
var _cy = (bbox_top + bbox_bottom) / 2;
var _dx = 0;
var _en_campo = false;

if (instance_exists(oPlayer)) {
    var _py = (oPlayer.bbox_top + oPlayer.bbox_bottom) / 2;
    _dx = oPlayer.x - x;

    _en_campo = abs(_dx) <= rango_vision
             && abs(_cy - _py) < alto_campo
             && !collision_line(x, _cy, oPlayer.x, _py, obj_wall, false, true);

    // Mira a Gaby (salvo cuando está sobrecargada)
    if (estado != ESTADO_IMAN.SOBRECARGA) {
        image_xscale = (_dx > 0) ? 1 : -1;
    }
}

// --- MÁQUINA DE ESTADOS ---
switch (estado) {

    case ESTADO_IMAN.ESPERA:
        image_blend = c_white;

        // Solo carga el imán si Gaby está cerca
        if (timer <= 0 && instance_exists(oPlayer) && abs(_dx) <= rango_vision + 80) {
            estado = ESTADO_IMAN.AVISO;
            timer = tiempo_aviso;
        }
        break;

    case ESTADO_IMAN.AVISO:
        // Parpadea mientras carga: el campo todavía no tira
        image_blend = (timer mod 8 < 4) ? c_white : make_color_rgb(150, 220, 255);

        if (timer <= 0) {
            image_blend = c_white;
            estado = ESTADO_IMAN.ACTIVO;
            timer = tiempo_activo;
        }
        break;

    case ESTADO_IMAN.ACTIVO:
        if (_en_campo && abs(_dx) > distancia_nucleo) {
            // Más fuerte cuanto más cerca, y arranca poco a poco
            var _cerca = 1 - (abs(_dx) / rango_vision);
            var _arranque = min(1, (tiempo_activo - timer) / 15);
            var _f = lerp(fuerza_min, fuerza_max, _cerca) * _arranque;
            var _m = -sign(_dx) * min(_f, abs(_dx) - distancia_nucleo);

            // Mueve a Gaby respetando las paredes
            with (oPlayer) {
                if (!place_meeting(x + _m, y, obj_wall)) {
                    x += _m;
                } else {
                    var _s = sign(_m);
                    while (!place_meeting(x + _s, y, obj_wall)) x += _s;
                }
            }
        }

        if (timer <= 0) {
            estado = ESTADO_IMAN.SOBRECARGA;
            timer = tiempo_sobrecarga;
        }
        break;

    case ESTADO_IMAN.SOBRECARGA:
        // Se apaga un momento: ventana para atacarla
        image_blend = make_color_rgb(190, 200, 215);

        if (timer <= 0) {
            image_blend = c_white;
            estado = ESTADO_IMAN.ESPERA;
            timer = tiempo_espera;
        }
        break;
}

// --- DAÑO POR CONTACTO ---
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

            other.golpeo_gaby = true;
        }
    }
}

// Si atrapó a Gaby, el imán se sobrecarga (hueco para pegarle)
if (golpeo_gaby) {
    golpeo_gaby = false;
    if (estado == ESTADO_IMAN.ACTIVO || estado == ESTADO_IMAN.AVISO) {
        estado = ESTADO_IMAN.SOBRECARGA;
        timer = tiempo_sobrecarga + 30;
    }
}