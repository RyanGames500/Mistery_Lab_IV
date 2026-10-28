var oPlayer = obj_jugador;

if (!iniciada) {
    iniciada = true;
    //x = (arena_izq + arena_der) / 2;
    //y = arena_arriba + 90;
    //objetivo_x = x;
    //objetivo_y = y;

    // Cinemática de presentación
    with (obj_camera) iniciar_cine(other.x-164, other.y-64, 1.8, 150, "Reina del Eter");
}

// Mientras dura la cinemática, la Reina no ataca
if (global.cinematica) exit;

// --- La arena sigue a la cámara (así la Reina siempre está a la vista) ---
var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);

arena_izq    = max(32, _cx + 48);
arena_der    = min(room_width - 32, _cx + _cw - 48);
arena_arriba = max(32, _cy + 48);
arena_abajo  = min(room_height - 32, _cy + _ch - 48);


if (timer > 0) timer--;
if (cooldown > 0) cooldown--;
if (inv_timer > 0) inv_timer--;

// Cambio a fase 2
if (fase == 1 && hp <= hp_max * 0.5) {
    fase = 2;
    cooldown = 40;
}

switch (estado) {

    case ESTADO_REINA.FLOTANDO:
        // Cambia de lugar cada cierto tiempo
        if (timer <= 0) {
            objetivo_x = random_range(arena_izq + 96, arena_der - 96);
            objetivo_y = random_range(arena_arriba + 60, arena_arriba + 200);
            timer = 80;
        }
        x = lerp(x, objetivo_x, 0.03);
        y = lerp(y, objetivo_y, 0.03);

        if (cooldown <= 0) {
            // Elige un ataque distinto al anterior
            var _a = irandom(2);
            if (_a == ultimo_ataque) _a = (_a + 1 + irandom(1)) mod 3;
            ataque_actual = _a;
            ultimo_ataque = _a;

            estado = ESTADO_REINA.AVISO;
            timer = 40;
        }
        break;

    case ESTADO_REINA.AVISO:
        // Brilla mientras se prepara (se dibuja en Draw)
        if (timer <= 0) {
            if (ataque_actual == 0) {
                // --- LLUVIA ASTRAL ---
                lluvia_restantes = (fase == 1) ? 12 : 20;
                timer = 0;
                estado = ESTADO_REINA.LLUVIA;
            }
            else if (ataque_actual == 1) {
                // --- TORMENTA ASCENDENTE ---
                var _px = instance_exists(oPlayer) ? oPlayer.x : x;
                for (var i = 0; i < fase; i++) {
                    var _cx = clamp(_px + random_range(-120, 120) + i * choose(-1, 1) * 260, arena_izq + 80, arena_der - 80);
                    var _c = instance_create_layer(_cx, arena_arriba, layer, obj_corriente);
                    _c.y_top = arena_arriba - 64;
                    _c.y_bot = arena_abajo + 64;
                }
                timer = 280;
                estado = ESTADO_REINA.TORMENTA;
            }
            else {
                // --- EMBESTIDA CELESTIAL ---
                emb_restantes = fase;   // 1 pasada en fase 1, 2 en fase 2
                timer = 70;
                estado = ESTADO_REINA.APUNTANDO;
            }
        }
        break;

    case ESTADO_REINA.LLUVIA:
        // Se mantiene arriba mientras llueve
        y = lerp(y, arena_arriba + 80, 0.05);

        if (timer <= 0 && lluvia_restantes > 0) {
            var _px = instance_exists(oPlayer) ? oPlayer.x : x;
            var _sx = clamp(_px + random_range(-240, 240), arena_izq, arena_der);
            var _sy = camera_get_view_y(view_camera[0]) + 24; // arriba de la pantalla
            instance_create_layer(_sx, _sy, layer, obj_astral);
            lluvia_restantes--;
            timer = (fase == 1) ? 14 : 9;
        }

        if (lluvia_restantes <= 0 && timer <= 0) {
            estado = ESTADO_REINA.CANSADA;
            timer = 100;
        }
        break;

    case ESTADO_REINA.TORMENTA:
        // Queda flotando mientras la corriente hace su trabajo
        x = lerp(x, (arena_izq + arena_der) / 2, 0.02);
        y = lerp(y, arena_arriba + 100, 0.03);

        // --- FUEGO CRUZADO ---
        if (fuego_timer > 0) fuego_timer--;

        // Empieza cuando la corriente ya empuja y para antes de que termine
        if (timer <= 235 && timer > 40 && fuego_timer <= 0) {
            fuego_timer = (fase == 1) ? 45 : 30;

            var _desde_izq = choose(true, false);
            var _sx = _desde_izq ? arena_izq - 16 : arena_der + 16;

            // La mitad apunta a la altura de Gaby, el resto cae en altura aleatoria
            var _sy;
            if (instance_exists(oPlayer) && irandom(1) == 0) {
                _sy = oPlayer.y;
            } else {
                _sy = random_range(arena_arriba + 60, arena_abajo - 60);
            }
            _sy = clamp(_sy, arena_arriba + 40, arena_abajo - 40);

            var _o = instance_create_layer(_sx, _sy, layer, obj_orbe_reina);
            _o.hsp = (_desde_izq ? 1 : -1) * ((fase == 1) ? 2.2 : 2.8);
        }

        if (timer <= 0) {
            estado = ESTADO_REINA.CANSADA;
            timer = 100;
        }
        break;

    case ESTADO_REINA.APUNTANDO:
        if (instance_exists(oPlayer)) {
            // Primero se coloca en un extremo de la arena, lejos de Gaby
            if (timer > 25) {
                var _lado_x = (oPlayer.x > (arena_izq + arena_der) / 2) ? arena_izq : arena_der;
                x = lerp(x, _lado_x, 0.12);
                y = lerp(y, clamp(oPlayer.y - 60, arena_arriba + 40, arena_abajo - 40), 0.12);
            }
            // Fija la trayectoria a 25 frames del ataque (se ve la línea)
            if (timer == 25) {
                emb_dir = point_direction(x, y, oPlayer.x, oPlayer.y);
            }
        }
        if (timer <= 0) {
            estado = ESTADO_REINA.EMBESTIDA;
            timer = 90; // tope de seguridad
        }
        break;

    case ESTADO_REINA.EMBESTIDA:
        x += lengthdir_x(emb_vel, emb_dir);
        y += lengthdir_y(emb_vel, emb_dir);

        // Termina al salir de la arena (o por tiempo)
        if (timer <= 0
            || x < arena_izq - 140 || x > arena_der + 140
            || y < arena_arriba - 140 || y > arena_abajo + 140) {

            emb_restantes--;
            if (emb_restantes > 0) {
                estado = ESTADO_REINA.APUNTANDO;
                timer = 45;
            } else {
                // Regresa dentro de la arena
                x = clamp(x, arena_izq, arena_der);
                y = clamp(y, arena_arriba, arena_abajo);
                estado = ESTADO_REINA.CANSADA;
                timer = 100;
            }
        }

        // Daño por contacto SOLO durante la embestida
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
                    vsp = -4;
                }
            }
        }
        break;

    case ESTADO_REINA.CANSADA:
        // Ventana de castigo: se queda casi quieta
        y = lerp(y, y + 30, 0.02);
        if (timer <= 0) {
            estado = ESTADO_REINA.FLOTANDO;
            timer = 0;
            cooldown = (fase == 1) ? 50 : 25;
        }
        break;
}