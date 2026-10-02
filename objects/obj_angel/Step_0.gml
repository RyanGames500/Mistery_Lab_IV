var oPlayer = obj_jugador;

// Stun / miel
if (stun_timer > 0) { stun_timer--; exit; }

if (timer > 0) timer--;

// --- FLOTAR (sube y baja suave + transición a la altura objetivo) ---
t_flotar += 0.06;
y_base = lerp(y_base, altura_objetivo, 0.05);
y = y_base + sin(t_flotar) * 3;

// Mirar a Gaby
if (instance_exists(oPlayer)) {
    dir = (oPlayer.x > x) ? 1 : -1;
    image_xscale = dir;
}

// --- MÁQUINA DE ESTADOS ---
switch (estado) {

    case ESTADO_ANGEL.FLOTANDO:
        if (timer <= 0 && instance_exists(oPlayer)) {
            var _dx = abs(x - oPlayer.x);
            var _dy = abs(y - oPlayer.y);
            if (_dx <= rango_ataque && _dy <= rango_vertical) {
                estado = ESTADO_ANGEL.CARGANDO;
                timer = 35;          // advertencia
                rondas_hechas = 0;
            }
        }
        break;

    case ESTADO_ANGEL.CARGANDO:
        // Aquí puedes poner brillo/animación de carga
        if (timer <= 0) {
            estado = ESTADO_ANGEL.DISPARANDO;
            timer = 0;
        }
        break;

    case ESTADO_ANGEL.DISPARANDO:
        if (timer <= 0) {
            // Alterna entre dos patrones para que cambien los huecos
            var _angulos;
            if (patron == 0) _angulos = [20, 50, 80];   // hueco en medio
            else             _angulos = [35, 65];       // hueco arriba y abajo
            patron = 1 - patron;

            for (var i = 0; i < array_length(_angulos); i++) {
                var _a = _angulos[i];
                // Diagonales hacia abajo en la dirección que mira
                var _dir_disparo = (dir == 1) ? (360 - _a) : (180 + _a);

                var _f = instance_create_layer(x, y, layer, obj_fragmento);
                _f.direction = _dir_disparo;
                _f.speed = vel_fragmento;
                _f.image_angle = _dir_disparo;
            }

            rondas_hechas++;
            timer = 30; // pausa entre rondas

            if (rondas_hechas >= rondas_totales) {
                estado = ESTADO_ANGEL.CAMBIANDO_ALTURA;
                timer = 70;

                // Elegir una altura nueva distinta y libre de paredes
                var _nueva = altura_objetivo;
                repeat (10) {
                    var _try = y_suelo + alturas[irandom(array_length(alturas) - 1)];
                    if (abs(_try - altura_objetivo) > 4 && !place_meeting(x, _try, obj_wall)) {
                        _nueva = _try;
                        break;
                    }
                }
                altura_objetivo = _nueva;
            }
        }
        break;

    case ESTADO_ANGEL.CAMBIANDO_ALTURA:
        // Se mueve a la nueva altura (lo hace el lerp de arriba)
        if (timer <= 0) {
            estado = ESTADO_ANGEL.FLOTANDO;
            timer = 60; // cooldown
        }
        break;
}