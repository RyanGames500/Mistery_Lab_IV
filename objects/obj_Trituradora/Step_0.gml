var oPlayer = obj_jugador;

if (global.cinematica) exit;

// Súper armadura: los golpes no alteran su ritmo (hay que poder leerlo)
stun_timer = 0;

if (timer > 0) timer--;
temblor = 0;
image_blend = c_white;

var _suelo_y = y_destino + alto_pie;

switch (estado) {

    case ESTADO_TRITURADORA.ESPERA:
        // Solo arranca el ciclo si Gaby está cerca
        if (timer <= 0 && instance_exists(oPlayer) && abs(oPlayer.x - x) <= rango_activacion) {
            estado = ESTADO_TRITURADORA.PREPARACION;
            timer = tiempo_aviso;
        }
        break;

    case ESTADO_TRITURADORA.PREPARACION:
        // Tiembla cada vez más fuerte y parpadea
        temblor = 0.5 + (1 - timer / tiempo_aviso) * 2;
        if (timer mod 8 < 4) image_blend = make_color_rgb(255, 190, 150);

        if (timer <= 0) {
            estado = ESTADO_TRITURADORA.CAIDA;
            vel_caida = 4;
        }
        break;

    case ESTADO_TRITURADORA.CAIDA:
        // Cae acelerando (sin teletransportarse)
        vel_caida += 1.4;
        y = min(y + vel_caida, y_destino);

        if (place_meeting(x, y, obj_jugador)) hacer_dano();

        if (y >= y_destino) {
            estado = ESTADO_TRITURADORA.GOLPE;
            timer = tiempo_golpe;
            onda_timer = ventana_onda;
            screen_shake(fuerza_impacto);
        }
        break;

    case ESTADO_TRITURADORA.GOLPE:
        if (place_meeting(x, y, obj_jugador)) hacer_dano();

        // Onda de choque: solo daña a Gaby si está en el suelo
        if (onda_timer > 0) {
            onda_timer--;

            if (instance_exists(oPlayer)) {
                var _en_suelo = false;
                with (oPlayer) {
                    _en_suelo = place_meeting(x, y + 1, obj_wall)
                             || place_meeting(x, y + 1, obj_hielo)
                             || place_meeting(x, y + 1, obj_plataforma_movil)
                             || place_meeting(x, y + 1, obj_plataforma_caida)
                             || place_meeting(x, y + 1, obj_plataforma_atravesable);
                }

                if (_en_suelo
                    && abs(oPlayer.x - x) <= rango_onda
                    && abs(oPlayer.bbox_bottom - _suelo_y) < 24) {
                    hacer_dano();
                }
            }
        }

        if (timer <= 0) {
            estado = ESTADO_TRITURADORA.RECUPERACION;
        }
        break;

    case ESTADO_TRITURADORA.RECUPERACION:
        // Sube lento: ventana para pegarle
        y = max(y - vel_subida, y_original);

        if (y <= y_original) {
            estado = ESTADO_TRITURADORA.ESPERA;
            timer = tiempo_espera;
        }
        break;
}