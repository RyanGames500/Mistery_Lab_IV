vida--;
radio += (radio_max - radio) * suave;

if (dano) {
    var _lista = ds_list_create();
    var _n = collision_circle_list(x, y, radio + 10, obj_enemy_parent, false, true, _lista, false);
    for (var i = 0; i < _n; i++) {
        var _e = _lista[| i];
        if (!instance_exists(_e)) continue;

        if (ds_list_find_index(golpeados, _e) == -1) {
            ds_list_add(golpeados, _e);

            var _ex = _e.x;
            var _ey = _e.y - 14;

            enemigo_recibir_dano(_e, dano_valor, stun);

            repeat (6) {
                var _c = instance_create_layer(_ex, _ey, "Instances", obj_efecto_chispa);
                _c.dir = random(360);
                _c.image_blend = make_color_rgb(159, 244, 255);
            }
        }
    }
    ds_list_destroy(_lista);
}

if (vida <= 0) instance_destroy();