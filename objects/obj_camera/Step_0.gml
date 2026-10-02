// --- SHAKE ---
var _x_shake = 0;
var _y_shake = 0;

if (shake_amount > 0.1) {
    _x_shake = random_range(-shake_amount, shake_amount);
    _y_shake = random_range(-shake_amount, shake_amount);
    shake_amount *= shake_friction;
} else {
    shake_amount = 0;
}

// Al cambiar de room
if (room != room_anterior) {
    room_anterior = room;
    iniciada = false;
    cine_activa = false;
    global.cinematica = false;
    zoom_actual = 1;
}

if (room == rm_main) {
    var _target_cam_w = 640;
    var _target_cam_h = 360;

    camera_set_view_size(view_camera[0], _target_cam_w, _target_cam_h);

    var _tx = (room_width / 2) - (_target_cam_w / 2);
    var _ty = (room_height / 2) - (_target_cam_h / 2);

    camera_set_view_pos(view_camera[0], round(_tx + _x_shake), round(_ty + _y_shake));

} else {

    // --- ZOOM (suave) ---
    var _zoom_obj = cine_activa ? cine_zoom : 1;
    zoom_actual = lerp(zoom_actual, _zoom_obj, 0.06);
    var _w = cam_width / zoom_actual;
    var _h = cam_height / zoom_actual;
    camera_set_view_size(view_camera[0], round(_w), round(_h));

    if (cine_activa) {
        // --- MODO CINEMÁTICA: enfoca el objetivo ---
        cine_timer--;
        cam_x = lerp(cam_x, cine_x - _w / 2, cine_spd);
        cam_y = lerp(cam_y, cine_y - _h / 2, cine_spd);

        if (cine_timer <= 0) {
            cine_activa = false;
            global.cinematica = false;
        }

    } else if (instance_exists(obj_jugador)) {
        // --- MODO NORMAL ---
        var _px = obj_jugador.x;
        var _py = obj_jugador.y;
        var _hsp = obj_jugador.hsp;

        var _suelo = false;
        with (obj_jugador) _suelo = place_meeting(x, y + 1, obj_wall);
        if (_suelo) suelo_timer = min(suelo_timer + 1, 10); else suelo_timer = 0;

        if (!iniciada) {
            cam_x = _px - _w / 2;
            cam_y = _py - _h * piso_pantalla;
            iniciada = true;
        }

        // Horizontal con look ahead
        if (abs(_hsp) > 0.1) facing = sign(_hsp);
        look_ahead = lerp(look_ahead, facing * look_dist, 0.04);

        var _target_x = (_px + look_ahead) - _w / 2;
        cam_x = lerp(cam_x, _target_x, spd_x);

        // Vertical
        if (suelo_timer >= 6) {
            var _target_y = _py - _h * piso_pantalla;
            cam_y = lerp(cam_y, _target_y, spd_y);
        } else {
            var _rel = _py - cam_y;
            var _lim_arriba = _h * borde_arriba;
            var _lim_abajo = _h * borde_abajo;

            if (_rel < _lim_arriba) {
                cam_y = lerp(cam_y, _py - _lim_arriba, spd_borde);
            } else if (_rel > _lim_abajo) {
                cam_y = lerp(cam_y, _py - _lim_abajo, spd_borde);
            }
        }
    }

    // Límites del room
    cam_x = clamp(cam_x, 0, max(0, room_width - _w));
    cam_y = clamp(cam_y, 0, max(0, room_height - _h));

    camera_set_view_pos(view_camera[0], round(cam_x + _x_shake), round(cam_y + _y_shake));
}