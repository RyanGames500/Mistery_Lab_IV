// Stun / miel
if (stun_timer > 0) { stun_timer--; exit; }

// Gravedad con colisión (queda pegada al suelo)
if (!place_meeting(x, y + 1, obj_wall)) vsp += grav; else vsp = 0;
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) y += sign(vsp);
    vsp = 0;
}
y += vsp;

if (timer > 0) timer--;

switch (estado) {

    case ESTADO_DRYAD.INACTIVA:
        // Inmóvil, esperando
        if (instance_exists(obj_jugador)) {
            var _dx = abs(x - obj_jugador.x);
            var _dy = abs(y - obj_jugador.y);
            if (_dx <= rango_ataque && _dy < 48) {
                dir = (obj_jugador.x > x) ? 1 : -1;
                image_xscale = dir;
                estado = ESTADO_DRYAD.CARGANDO;
                timer = 40; // advertencia
            }
        }
        break;

    case ESTADO_DRYAD.CARGANDO:
        // Aquí pones animación/brillo de que va a atacar
        if (timer <= 0) {
            estado = ESTADO_DRYAD.ATACANDO;
            raices_creadas = 0;
            timer = 0;
        }
        break;

    case ESTADO_DRYAD.ATACANDO:
        // Va haciendo brotar tramos uno tras otro
        if (timer <= 0) {
            var _sx = x + dir * (24 + raices_creadas * separacion);

            // Si una pared bloquea el camino, la ola se detiene
            if (raices_creadas >= raices_max || place_meeting(_sx, y, obj_wall)) {
                estado = ESTADO_DRYAD.RECUPERANDO;
                timer = 90; // ventana para que Gaby avance
            } else {
                instance_create_layer(_sx, bbox_bottom, layer, obj_raiz_segmento);
                raices_creadas++;
                timer = intervalo_raiz;
            }
        }
        break;

    case ESTADO_DRYAD.RECUPERANDO:
        if (timer <= 0) {
            estado = ESTADO_DRYAD.INACTIVA;
            timer = 60; // cooldown
        }
        break;
}