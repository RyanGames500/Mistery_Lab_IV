x += hsp * image_xscale;

if (x < 0 || x > room_width || y < 0 || y > room_height) {
    instance_destroy();
}

var _enemy = instance_place(x, y, obj_enemy_parent);
if (_enemy != noone) {
    with (_enemy) {
        instance_destroy(); 
    }
    instance_destroy();
}

if (place_meeting(x, y, obj_wall)) {
    instance_destroy();
}