enum ESTADO_REINA { FLOTANDO, AVISO, LLUVIA, TORMENTA, APUNTANDO, EMBESTIDA, CANSADA }

// --- Sprite invisible solo para la máscara de colisión ---
if (!variable_global_exists("spr_reina_mask")) {
    var _s = surface_create(40, 64);
    surface_set_target(_s);
    draw_clear_alpha(c_white, 1);
    surface_reset_target();
    global.spr_reina_mask = sprite_create_from_surface(_s, 0, 0, 40, 64, false, false, 20, 32);
    surface_free(_s);
}
sprite_index = global.spr_reina_mask;

// --- Vida ---
hp_max = 100;
hp = hp_max;
fase = 1;
inv_timer = 0;

// --- Arena (ajusta a tu room) ---
arena_izq = 32;
arena_der = room_width - 32;
arena_arriba = 32;
arena_abajo = room_height - 32;

// --- Estado ---
estado = ESTADO_REINA.FLOTANDO;
timer = 0;
cooldown = 90;
ataque_actual = 0;
ultimo_ataque = -1;

// --- Movimiento ---
objetivo_x = x;
objetivo_y = y;

// --- Lluvia ---
lluvia_restantes = 0;

// --- Embestida ---
emb_dir = 0;
emb_vel = 14;
emb_restantes = 0;

// --- Función para que Gaby le haga daño ---
recibir_dano = function(_d) {
    if (inv_timer > 0) return;
    hp -= _d;
    inv_timer = 30;
    if (hp <= 0) {
        // Aquí va tu victoria / drop / cinemática
        instance_destroy();
    }
};
iniciada = false;
hp_visible = hp_max;
fuego_timer = 0;