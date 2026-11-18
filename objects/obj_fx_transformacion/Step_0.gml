// Anillos
var _r = [];
for (var i = 0; i < array_length(rings); i++) {
    var _o = rings[i];
    if (_o.delay > 0) _o.delay--; else _o.t++;
    if (_o.t < _o.life) _r[array_length(_r)] = _o;
}
rings = _r;

// Chispas
var _s = [];
for (var i = 0; i < array_length(sparks); i++) {
    var _p = sparks[i];
    _p.x += _p.vx;
    _p.y += _p.vy;
    _p.vy += 0.12;
    _p.vx *= 0.985;
    _p.t++;
    if (_p.t < _p.life) _s[array_length(_s)] = _p;
}
sparks = _s;

if (flash > 0) flash--;
if (dim_t > 0) dim_t--;

// Nombre de la forma + segundo golpe cuando cambia el sprite
if (popup_delay > 0) {
    popup_delay--;
    if (popup_delay <= 0) {
        popup_t = 80;
        if (FX_FLASH)   { flash_len = 8; flash = 8; flash_max = 0.5; }
        if (FX_CHISPAS) fx_chispas(round(22 * k));
        if (FX_ONDAS)   rings[array_length(rings)] = { delay: 0, t: 0, life: 24, r1: 90 * k };
        if (FX_TEMBLOR) screen_shake(4 * k);
    }
}
if (popup_t > 0) popup_t--;

// Se destruye cuando ya no queda nada
if (fase == 2 && flash <= 0 && dim_t <= 0 && popup_t <= 0 && popup_delay <= 0
    && array_length(rings) == 0 && array_length(sparks) == 0) {
    instance_destroy();
}