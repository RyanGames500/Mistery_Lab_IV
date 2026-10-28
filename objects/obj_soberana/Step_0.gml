var oPlayer = obj_jugador;

// --- La arena sigue a la cámara (siempre a la vista) ---
var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
arena_izq    = max(32, _vx + 48);
arena_der    = min(room_width - 32, _vx + _vw - 48);
arena_arriba = max(32, _vy + 48);
arena_abajo  = min(room_height - 32, _vy + _vh - 48);

// --- Espera a Gaby y presenta a la jefa ---
if (!activada) {
    if (!instance_exists(oPlayer) || point_distance(x, y, oPlayer.x, oPlayer.y) > 450) exit;
    activada = true;
}
if (!intro_hecha) {
    intro_hecha = true;
    x = (arena_izq + arena_der) / 2;
    y = arena_arriba + 110;
    objetivo_x = x;
    objetivo_y = y;
    with (obj_camera) iniciar_cine(other.x-164, other.y, 1.8, 150, "Soberana del Equilibrio");
}
if (global.cinematica) exit;
if (muerta) exit;

if (timer > 0) timer--;
if (cooldown > 0) cooldown--;
if (inv_timer > 0) inv_timer--;
temblor = 0;

// Fase 2
if (fase == 1 && hp <= hp_max * 0.5) {
    fase = 2;
    screen_shake(6);
    cooldown = 40;
}

// --- MÁQUINA DE ESTADOS ---
switch (estado) {

    case ESTADO_SOB.FLOTA:
        if (timer <= 0) {
            objetivo_x = random_range(arena_izq + 100, arena_der - 100);
            objetivo_y = random_range(arena_arriba + 70, arena_arriba + 180);
            timer = 90;
        }
        x = lerp(x, objetivo_x, 0.03);
        y = lerp(y, objetivo_y, 0.03);

        if (cooldown <= 0) {
            var _a = irandom(2);
            if (_a == ultimo_ataque) _a = (_a + 1 + irandom(1)) mod 3;
            ataque_actual = _a;
            ultimo_ataque = _a;

            aviso_total = (fase == 1) ? 55 : 40;
            estado = ESTADO_SOB.AVISO;
            timer = aviso_total;
        }
        break;

    case ESTADO_SOB.AVISO:
        temblor = 1 + (1 - timer / aviso_total) * 2;

        if (timer <= 0) {
            if (ataque_actual == 0) {
                // PULSO DIMENSIONAL
                crear_zonas();
                fuego_timer = 0;
                estado = ESTADO_SOB.PULSO;
                timer = zona_dur;
            }
            else if (ataque_actual == 1) {
                // FRAGMENTOS
                oleadas_restantes = (fase == 1) ? 3 : 4;
                timer = 0;
                estado = ESTADO_SOB.FRAGMENTOS;
            }
            else {
                // RUPTURA
                rup_restantes = (fase == 1) ? 3 : 4;
                elegir_destino();
                estado = ESTADO_SOB.RUP_MARCA;
                timer = (fase == 1) ? 38 : 28;
            }
        }
        break;

    case ESTADO_SOB.PULSO:
        x = lerp(x, (arena_izq + arena_der) / 2, 0.02);
        y = lerp(y, arena_arriba + 100, 0.03);

        // Mientras las zonas alteran la física, lanza fragmentos lentos
        if (fuego_timer > 0) fuego_timer--;
        if (timer <= zona_dur - 60 && timer > 40 && fuego_timer <= 0) {
            fuego_timer = (fase == 1) ? 80 : 55;
            var _izq = choose(true, false);
            var _yy = instance_exists(oPlayer) ? clamp(oPlayer.y, arena_arriba + 20, arena_abajo - 20) : (arena_arriba + arena_abajo) / 2;
            crear_fragmento(_izq ? arena_izq : arena_der, _yy, _izq ? 0 : 180, (fase == 1) ? 3.6 : 4.4, 0);
        }

        if (timer <= 0) {
            estado = ESTADO_SOB.CANSADA;
            timer = 100;
        }
        break;

    case ESTADO_SOB.FRAGMENTOS:
        x = lerp(x, (arena_izq + arena_der) / 2, 0.03);
        y = lerp(y, arena_arriba + 90, 0.03);

        if (timer <= 0 && oleadas_restantes > 0) {
            lanzar_oleada();
            oleadas_restantes--;
            timer = (fase == 1) ? 120 : 95;
        }
        if (oleadas_restantes <= 0 && timer <= 0) {
            estado = ESTADO_SOB.CANSADA;
            timer = (fase == 1) ? 100 : 70;
        }
        break;

    case ESTADO_SOB.RUP_MARCA:
        // Se desvanece mientras el portal marca el destino (se dibuja en Draw)
        if (timer <= 0) {
            x = dest_x;
            y = dest_y;
            estado = ESTADO_SOB.RUP_IMPACTO;
            timer = 26;

            var _i = instance_create_layer(x, y, layer, obj_impacto_dim);
            _i.r_max = (fase == 1) ? 140 : 170;
            screen_shake(6);

            // El escenario cambia en cada teletransporte
            with (obj_plataforma_dim) {
                if (irandom(99) < 45) alternar();
            }
            with (obj_corriente_fija) {
                if (irandom(99) < 50) invertir();
            }            
            rup_restantes--;
        }
        break;

    case ESTADO_SOB.RUP_IMPACTO:
        if (timer <= 0) {
            if (rup_restantes > 0) {
                elegir_destino();
                estado = ESTADO_SOB.RUP_MARCA;
                timer = (fase == 1) ? 38 : 28;
            } else {
                estado = ESTADO_SOB.CANSADA;
                timer = (fase == 1) ? 100 : 70;
            }
        }
        break;

    case ESTADO_SOB.CANSADA:
        // Ventana de castigo: baja lento
        y = min(y + 0.25, arena_abajo - 40);
        if (timer <= 0) {
            estado = ESTADO_SOB.FLOTA;
            timer = 0;
            cooldown = (fase == 1) ? 60 : 30;
        }
        break;
}