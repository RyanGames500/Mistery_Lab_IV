enum ESTADO_EMP { ACECHA, AVISO, MARTILLO, NUCLEO, CARGA, ATURDIDA, CANSADA }

// --- Sprite invisible para la máscara (64x96, origen abajo al centro) ---
if (!variable_global_exists("spr_emp_mask")) {
    var _s = surface_create(64, 96);
    surface_set_target(_s);
    draw_clear_alpha(c_white, 1);
    surface_reset_target();
    global.spr_emp_mask = sprite_create_from_surface(_s, 0, 0, 64, 96, false, false, 32, 96);
    surface_free(_s);
}
sprite_index = global.spr_emp_mask;

// --- Física ---
hsp = 0;
vsp = 0;
grav = 0.5;
dir = -1;
choco = false;

// --- Vida ---
hp_max = 300;
hp = hp_max;
hp_visible = hp_max;
fase = 1;
inv_timer = 0;
muerta = false;

// --- Control de combate ---
estado = ESTADO_EMP.ACECHA;
timer = 0;
cooldown = 90;
ataque_actual = 0;
ultimo_ataque = -1;
aviso_total = 50;
temblor = 0;
brazo = 0;                 // 0 = brazos abajo, 1 = alzados
vel_acecho = 0.5;

// --- Intro ---
activada = false;
intro_hecha = false;

// --- Martillo Sísmico ---
onda2_timer = -1;

// --- Núcleo Magnético ---
rango_nucleo = 420;
alto_nucleo = 140;
fuerza_min = 2;
fuerza_max = 4.2;
nucleo_dur = 150;
nucleo_total = 150;

// --- Carga Colosal ---
carga_dir = 1;
carga_vel = 0;
carga_vel_max = 9;

// --- Ondas del martillo (hacia ambos lados) ---
crear_ondas = function() {
    for (var i = -1; i <= 1; i += 2) {
        var _o = instance_create_layer(x + i * 36, y, layer, obj_onda_sismica);
        _o.hsp = i * ((fase == 1) ? 4.5 : 5.5);
    }
};

// --- Daño estándar a Gaby ---
hacer_dano = function() {
    if (!instance_exists(obj_jugador)) return;
    var _ex = x;
    with (obj_jugador) {
        if (!is_dead && !is_transforming && !invincible) {
            player_take_damage(1, false, 1);
            if (global.hp <= 0) {
                is_dead = true;
            }
            invincible = true;
            alarm[2] = 90;

            var _dir_empuje = sign(x - _ex);
            if (_dir_empuje == 0) _dir_empuje = 1;
            hsp = _dir_empuje * 5;
            vsp = -3;
        }
    }
};

// --- Función para que Gaby le haga daño ---
recibir_dano = function(_d) {
    if (inv_timer > 0 || muerta) return;
    if (estado == ESTADO_EMP.ATURDIDA) _d *= 2;   // aturdida = doble daño
    hp -= _d;
    inv_timer = 20;

    if (hp <= 0) {
        muerta = true;
        var _mx = x;
        var _my = y - 48;
        with (obj_onda_sismica) instance_destroy();
        with (obj_camera) iniciar_cine(_mx, _my, 2, 100);
        alarm[0] = 100;
    }
};