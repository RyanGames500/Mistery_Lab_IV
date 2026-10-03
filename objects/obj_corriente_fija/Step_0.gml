if (global.pausado || global.cinematica) exit;

var _dx = round(lengthdir_x(1, direccion));
var _dy = round(lengthdir_y(1, direccion));

// Inversión con aviso: durante el aviso no empuja
if (aviso_inv > 0) {
    aviso_inv--;
    if (aviso_inv <= 0) direccion = (direccion + 180) mod 360;
}

// Ciclo encendida / apagada
if (intermitente) {
    ciclo++;
    var _tot = t_on + t_off;
    var _c = ciclo mod _tot;
    activa = (_c < t_on);
    avisando = (!activa && _c >= _tot - t_aviso);
} else {
    activa = true;
    avisando = false;
}

if (!activa || aviso_inv > 0) exit;

var oPlayer = obj_jugador;
if (!instance_exists(oPlayer)) exit;
if (collision_rectangle(x, y, x + ancho, y + alto, oPlayer, false, false) == noone) exit;

if (_dy != 0) {
    // --- VERTICAL ---
    with (oPlayer) {
        var _vuela = is_transformed && (transform_type == 3 || transform_type == 4 || transform_type == 5
                  || transform_type == 7 || transform_type == 8 || transform_type == 9 || transform_type == 10);
        if (_vuela) {
            viento_y = _dy * other.fuerza;
        } else if (_dy < 0) {
            if (vsp > -other.fuerza * 1.4) vsp = max(vsp - other.fuerza * 0.22, -other.fuerza * 1.4);
        } else {
            if (vsp < other.fuerza * 2) vsp = min(vsp + other.fuerza * 0.22, other.fuerza * 2);
        }
    }
} else {
    // --- HORIZONTAL (respeta las paredes) ---
    var _m = _dx * fuerza;
    with (oPlayer) {
        if (!place_meeting(x + _m, y, obj_wall)) {
            x += _m;
        } else {
            var _s = sign(_m);
            while (!place_meeting(x + _s, y, obj_wall)) x += _s;
        }
    }
}