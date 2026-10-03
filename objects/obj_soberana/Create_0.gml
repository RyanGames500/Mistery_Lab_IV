enum ESTADO_SOB { FLOTA, AVISO, PULSO, FRAGMENTOS, RUP_MARCA, RUP_IMPACTO, CANSADA }

// --- Sprite invisible para la máscara (40x72, origen al centro) ---
if (!variable_global_exists("spr_sob_mask")) {
    var _s = surface_create(40, 72);
    surface_set_target(_s);
    draw_clear_alpha(c_white, 1);
    surface_reset_target();
    global.spr_sob_mask = sprite_create_from_surface(_s, 0, 0, 40, 72, false, false, 20, 36);
    surface_free(_s);
}
sprite_index = global.spr_sob_mask;

// --- Vida ---
hp_max = 400;
hp = hp_max;
hp_visible = hp_max;
fase = 1;
inv_timer = 0;
muerta = false;

// --- Arena (se recalcula cada frame desde la cámara) ---
arena_izq = 32;
arena_der = room_width - 32;
arena_arriba = 32;
arena_abajo = room_height - 32;

// --- Control de combate ---
estado = ESTADO_SOB.FLOTA;
timer = 0;
cooldown = 90;
ataque_actual = 0;
ultimo_ataque = -1;
aviso_total = 50;
temblor = 0;
objetivo_x = x;
objetivo_y = y;
activada = false;
intro_hecha = false;

// --- Pulso ---
zona_dur = 300;
fuego_timer = 0;

// --- Fragmentos ---
oleadas_restantes = 0;
ultimo_patron = -1;

// --- Ruptura ---
rup_restantes = 0;
dest_x = 0;
dest_y = 0;

// --- Crea un fragmento (se mueve solo tras su aviso) ---
crear_fragmento = function(_x, _y, _dir, _vel, _tipo) {
    var _f = instance_create_layer(_x, _y, layer, obj_fragmento_eq);
    _f.dir_mov = _dir;
    _f.vel_mov = _vel;
    _f.tipo = _tipo;
};

// --- Pulso Dimensional: columnas ligeras y pesadas alternadas ---
crear_zonas = function() {
    var _n = (fase == 1) ? 3 : 4;
    var _ancho = (arena_der - arena_izq) / _n;
    var _base = choose(-1, 1);
    for (var i = 0; i < _n; i++) {
        var _z = instance_create_layer(arena_izq + i * _ancho, arena_arriba, layer, obj_zona_gravedad);
        _z.z_x1 = arena_izq + i * _ancho;
        _z.z_x2 = arena_izq + (i + 1) * _ancho;
        _z.z_y1 = arena_arriba - 64;
        _z.z_y2 = arena_abajo + 96;
        _z.tipo = (i mod 2 == 0) ? _base : -_base;   // -1 ligera, 1 pesada
        _z.timer = zona_dur;
    }
};

// --- Fragmentos del Equilibrio: una oleada ---
lanzar_oleada = function() {
    var _p = irandom(2);
    if (_p == ultimo_patron) _p = (_p + 1 + irandom(1)) mod 3;
    ultimo_patron = _p;

    var _alto = arena_abajo - arena_arriba;
    var _ancho = arena_der - arena_izq;
    var _vel_m = (fase == 1) ? 3.6 : 4.4;   // materia: lenta
    var _vel_e = (fase == 1) ? 5.2 : 6.2;   // energía: rápida

    if (_p == 0) {
        // HORIZONTALES: franjas con un hueco para pasar
        var _n = (fase == 1) ? 3 : 4;
        var _hueco = irandom(_n - 1);
        for (var i = 0; i < _n; i++) {
            if (i == _hueco) continue;
            var _yy = arena_arriba + (i + 0.5) * (_alto / _n);
            var _izq = (i mod 2 == 0);
            var _tipo = i mod 2;
            crear_fragmento(_izq ? arena_izq : arena_der, _yy, _izq ? 0 : 180, _tipo ? _vel_e : _vel_m, _tipo);
        }
    }
    else if (_p == 1) {
        // VERTICALES: columnas con un hueco
        var _n = (fase == 1) ? 5 : 7;
        var _hueco = irandom(_n - 1);
        for (var i = 0; i < _n; i++) {
            if (i == _hueco) continue;
            var _xx = arena_izq + (i + 0.5) * (_ancho / _n);
            var _baja = (i mod 2 == 0);
            var _tipo = i mod 2;
            crear_fragmento(_xx, _baja ? arena_arriba : arena_abajo, _baja ? 270 : 90, _tipo ? _vel_e : _vel_m, _tipo);
        }
    }
    else {
        // DIAGONALES: desde arriba y desde abajo
        var _n = (fase == 1) ? 4 : 6;
        for (var i = 0; i < _n; i++) {
            var _arriba = (i mod 2 == 0);
            var _xx = arena_izq + (i + 0.5) * (_ancho / _n) + random_range(-20, 20);
            var _ang = _arriba ? choose(225, 315) : choose(45, 135);
            var _tipo = irandom(1);
            crear_fragmento(_xx, _arriba ? arena_arriba : arena_abajo, _ang, _tipo ? _vel_e : _vel_m, _tipo);
        }
    }
};

// --- Ruptura: elige a dónde se teletransporta ---
elegir_destino = function() {
    var _ok = false;
    repeat (16) {
        var _cx, _cy;
        if (instance_exists(obj_jugador) && irandom(99) < 60) {
            // Presión ofensiva: aparece cerca de Gaby
            _cx = obj_jugador.x + choose(-1, 1) * random_range(90, 200);
            _cy = obj_jugador.y - random_range(0, 70);
        } else {
            _cx = random_range(arena_izq + 60, arena_der - 60);
            _cy = random_range(arena_arriba + 60, arena_abajo - 80);
        }
        _cx = clamp(_cx, arena_izq + 40, arena_der - 40);
        _cy = clamp(_cy, arena_arriba + 50, arena_abajo - 60);

        if (point_distance(_cx, _cy, x, y) < 140) continue;
        if (place_meeting(_cx, _cy, obj_wall)) continue;

        dest_x = _cx;
        dest_y = _cy;
        _ok = true;
        break;
    }
    if (!_ok) {
        dest_x = (arena_izq + arena_der) / 2;
        dest_y = arena_arriba + 120;
    }
};

// --- Función para que Gaby le haga daño ---
recibir_dano = function(_d) {
    if (inv_timer > 0 || muerta) return;
    hp -= _d;
    inv_timer = 20;

    if (hp <= 0) {
        muerta = true;
        var _mx = x;
        var _my = y;
        with (obj_fragmento_eq) instance_destroy();
        with (obj_zona_gravedad) instance_destroy();
        with (obj_impacto_dim) instance_destroy();
        with (obj_plataforma_dim) mostrar();
        with (obj_camera) iniciar_cine(_mx, _my, 2, 100);
        alarm[0] = 100;
    }
};