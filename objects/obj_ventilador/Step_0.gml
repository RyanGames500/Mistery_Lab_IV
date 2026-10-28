if (global.pausado || global.cinematica) exit;

if (intermitente) {
    ciclo++;
    activo = ((ciclo mod (t_on + t_off)) < t_on);
}
if (!activo) exit;

var _p = collision_rectangle(bbox_left, bbox_top - alto_aire, bbox_right, bbox_bottom, obj_jugador, false, false);

if (_p != noone) {
    var _k = lerp(1, 0.6, clamp((bbox_top - _p.y) / alto_aire, 0, 1));
    var _v = vel_subida * _k;
    var _s = suavidad;

    with (_p) {
        var _vuela = is_transformed && (transform_type == 3 || transform_type == 4 || transform_type == 5
                  || transform_type == 7 || transform_type == 8 || transform_type == 9 || transform_type == 10
                  || transform_type == 11 || transform_type == 12);

        if (_vuela) {
            viento_y = -_v * 0.8;
        } else {
            var _objetivo = -_v;
            if (is_transformed && (transform_type == 1 || transform_type == 6)) _objetivo *= 1.2;
            vsp = lerp(vsp, _objetivo, _s);
        }
    }
}