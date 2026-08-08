function screen_shake(_intensidad) {
    with(obj_camera) {
        shake_amount = max(shake_amount, _intensidad);
    }
}