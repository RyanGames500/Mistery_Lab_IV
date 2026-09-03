// El misil acelera hacia abajo imitando una caída de bomba/misil
vsp += aceleracion;

// Movimiento horizontal y vertical
x += hsp;
y += vsp;

//Si choca con una pared o el suelo, se destruye
if (place_meeting(x, y, obj_wall)) {
    //instance_create_layer(x, y, "Instances", obj_explosion);
    instance_destroy();
}

// matar enemigos o romper terreno
var _enemy = instance_place(x, y, obj_enemy_parent); // Asegúrate de usar el nombre de tu objeto padre de enemigos
if (_enemy != noone) {
    // with (_enemy) {
    //     hp -= other.danio;
    // }
    instance_destroy();
}