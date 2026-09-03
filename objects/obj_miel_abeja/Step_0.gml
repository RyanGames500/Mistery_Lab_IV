vsp += grv_miel;
var _wave = sin(current_time * 0.03) * 0.4;
if (place_meeting(x + hsp, y, obj_wall)) {
    instance_destroy();
}
x += hsp;
if (place_meeting(x, y + vsp, obj_wall)) {
    instance_destroy();
}
y += vsp + _wave;