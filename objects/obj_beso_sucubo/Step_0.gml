y += sin(current_time * 0.015) * 1.5;

if (place_meeting(x + hsp, y, obj_wall)) {
    instance_destroy();
}
x += hsp;