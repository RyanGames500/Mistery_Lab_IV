t++;
x += hsp;

// estela de destellos
if (t % 3 == 0) {
    var _c = instance_create_layer(x, y + random_range(-4, 4), "Instances", obj_efecto_chispa);
    _c.dir = random(360);
    _c.velocidad_chispa = random_range(0.5, 1.5);
    _c.vida_util = irandom_range(10, 18);
    _c.image_blend = choose(make_color_rgb(255, 170, 255), make_color_rgb(255, 255, 160), c_white);
}

// elimina enemigos (igual que el rayo de la nube)
var _enemy = instance_place(x, y, obj_enemy_parent);
if (_enemy != noone) {
    with (_enemy) instance_destroy();
    instance_destroy();
    exit;
}

if (place_meeting(x, y, obj_wall)) {
    instance_destroy();
    exit;
}

vida--;
if (vida <= 0 || x < 0 || x > room_width) {
    instance_destroy();
}