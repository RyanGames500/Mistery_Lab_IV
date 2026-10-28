var oPlayer = obj_jugador;

// --- STUN / MIEL ---
if (stun_timer > 0) {
    stun_timer--;
    hsp = 0;
    vsp = 0;
    exit;
}

var _f = 1;
if (miel_timer > 0) {
    miel_timer--;
    _f = 0.5;   // más lenta, sin dañar su velocidad real
}

// --- ESTADOS ---
switch (estado) {

    case ESTADO_SLIME.REBOTANDO:
        // Mira a Gaby mientras rebota
        if (instance_exists(oPlayer)) dir = (oPlayer.x > x) ? 1 : -1;
        break;

    case ESTADO_SLIME.AGACHADA:
        hsp = 0;
        vsp = 0;
        if (timer > 0) timer--;

        if (timer <= 0) {
            // Despega: aterriza donde estaba Gaby al agacharse
            var _t_aire = (2 * abs(salto_vsp)) / grav;
            var _dx = abs(objetivo_x - x);
            hsp = dir * clamp(_dx / _t_aire, salto_hsp_min, salto_hsp_max);
            vsp = salto_vsp;
            esc_y = 1.25;
            estado = ESTADO_SLIME.SALTO_LARGO;
        }
        break;

    case ESTADO_SLIME.SALTO_LARGO:
        // En el aire: la trayectoria ya no cambia
        break;
}

// --- COLISIÓN HORIZONTAL ---
var _mx = hsp * _f;
if (_mx != 0 && place_meeting(x + _mx, y, obj_wall)) {
    while (!place_meeting(x + sign(_mx), y, obj_wall)) {
        x += sign(_mx);
    }
    hsp *= -0.6;   // rebota contra la pared
} else {
    x += _mx;
}

// --- GRAVEDAD Y COLISIÓN VERTICAL ---
if (estado != ESTADO_SLIME.AGACHADA) vsp += grav;

if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }

    if (vsp > 0) {
        // --- ATERRIZA ---
        esc_y = 0.65;

        switch (estado) {

            case ESTADO_SLIME.REBOTANDO:
                hsp = 0;
                rebotes++;
                if (rebotes >= rebotes_para_salto && instance_exists(oPlayer)
                    && abs(oPlayer.x - x) <= rango_vision && abs(oPlayer.y - y) < 96) {
                    // Se agacha: aviso del salto largo
                    dir = (oPlayer.x > x) ? 1 : -1;
                    objetivo_x = oPlayer.x;
                    estado = ESTADO_SLIME.AGACHADA;
                    timer = tiempo_aviso;
                    vsp = 0;
                } else {
                    vsp = vel_salto_rebote;
                }
                break;

            case ESTADO_SLIME.SALTO_LARGO:
                hsp = 0;
                screen_shake(1);
                estado = ESTADO_SLIME.REBOTANDO;
                rebotes = 0;
                rebotes_para_salto = irandom_range(2, 4);
                vsp = vel_salto_rebote;
                break;
        }
    } else {
        // Choca con un techo
        vsp = 0;
    }
}
y += vsp;

// --- VISUAL (la forma se anima en el Draw) ---
image_xscale = dir;

var _esc_obj = 1;
if (estado == ESTADO_SLIME.AGACHADA)  _esc_obj = 0.6;
else if (vsp < -2)                    _esc_obj = 1.2;
esc_y = lerp(esc_y, _esc_obj, 0.25);

// Parpadeo metálico mientras se agacha
if (estado == ESTADO_SLIME.AGACHADA) {
    image_blend = (timer mod 6 < 3) ? c_white : make_color_rgb(170, 200, 255);
} else {
    image_blend = c_white;
}

// --- DAÑO A GABY ---
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
            hsp = _dir_empuje * 4;
            vsp = -3;
        }
    }
}