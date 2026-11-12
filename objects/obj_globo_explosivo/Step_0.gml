t++;
x += hsp;
y = base_y + sin(t * 0.25 + fase) * 7 - t * 0.05;
image_angle = sin(t * 0.4) * 10;
image_xscale = 0.45 * (1 + sin(t * 0.5) * 0.08);
image_yscale = 0.45 * (1 - sin(t * 0.5) * 0.08);

// el centro visual del globo está unos 30 px arriba del origen
var _cy = y - 30;
var _boom = (t > 90)
    || collision_circle(x, _cy, 8, obj_wall, false, true) != noone
    || collision_circle(x, _cy, 14, obj_enemy_parent, false, true) != noone
    || x < 0 || x > room_width;

if (_boom) {
    // daño en área
    var _lista = ds_list_create();
    var _n = collision_circle_list(x, _cy, 36, obj_enemy_parent, false, true, _lista, false);
    for (var i = 0; i < _n; i++) enemigo_recibir_dano(_lista[| i], 10, 30);
    ds_list_destroy(_lista);

    // efectos
    fx_pop_globo(x, _cy, 16);
    var _onda = instance_create_layer(x, _cy, "Instances", obj_onda_pulso);
    _onda.radio_max = 28;
    _onda.vida_max = 12;
    _onda.vida = 12;
    _onda.suave = 0.3;
    _onda.dano = false;
    screen_shake(3);
    instance_destroy();
}