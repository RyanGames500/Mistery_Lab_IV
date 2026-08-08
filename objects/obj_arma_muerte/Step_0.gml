vsp += grv;

if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) {
        x += sign(hsp);
    }
    hsp = -hsp * 0.4; 
}
x += hsp;

if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = -vsp * 0.3; 
    hsp = lerp(hsp, 0, 0.2); 
}
y += vsp;

if (place_meeting(x, y + 1, obj_wall)) {
    rotacion_vel = 0;
    if (image_xscale > 0) {
        image_angle = 0;
    } else {
        image_angle = 180;
    }
    //image_alpha -= 0.015; 
    //if (image_alpha <= 0) {
        //instance_destroy(); 
    //}
} else {
    image_angle += rotacion_vel; 
}