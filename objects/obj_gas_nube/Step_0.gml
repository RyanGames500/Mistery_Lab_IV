x += hsp;

escala_actual = lerp(escala_actual, 1, 0.1);

vida_util--;
if (vida_util <= 0 || place_meeting(x, y, obj_wall)) {
    instance_destroy();
}