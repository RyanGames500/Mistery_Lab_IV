
var _x_shake = 0;
var _y_shake = 0;

if (shake_amount > 0.1) {
    _x_shake = random_range(-shake_amount, shake_amount);
    _y_shake = random_range(-shake_amount, shake_amount);
    shake_amount *= shake_friction;
} else {
    shake_amount = 0;
}

if (room == rm_main) {
    var _target_cam_w = 640; 
    var _target_cam_h = 360;
    
    camera_set_view_size(view_camera[0], _target_cam_w, _target_cam_h);
    
    var target_x = (room_width / 2) - (_target_cam_w / 2);
    var target_y = (room_height / 2) - (_target_cam_h / 2);
    
    camera_set_view_pos(view_camera[0], target_x + _x_shake, target_y + _y_shake);

} else {

    camera_set_view_size(view_camera[0], cam_width, cam_height);
    
    if (instance_exists(obj_jugador)) {
        var facing = 0;
        if (obj_jugador.hsp != 0) {
            facing = sign(obj_jugador.hsp);
        }
        look_ahead = lerp(look_ahead, facing * 20, 0.05);
        
        var target_x = (obj_jugador.x + look_ahead) - (cam_width / 2);
        var target_y = (obj_jugador.y - 16) - (cam_height / 2);
        
        var cam_x = camera_get_view_x(view_camera[0]);
        var cam_y = camera_get_view_y(view_camera[0]);
        
        var new_x = lerp(cam_x, target_x, cam_spd);
        var new_y = lerp(cam_y, target_y, cam_spd);
        
        new_x = clamp(new_x, 0, room_width - cam_width);
        new_y = clamp(new_y, 0, room_height - cam_height);
        
        camera_set_view_pos(view_camera[0], new_x + _x_shake, new_y + _y_shake);
    }
}