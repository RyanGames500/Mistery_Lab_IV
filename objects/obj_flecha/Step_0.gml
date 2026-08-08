
x += hsp;

if (place_meeting(x + sign(hsp), y, obj_wall)) {
    instance_destroy();
}