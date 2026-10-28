timer--;
if (timer <= 0) { instance_destroy(); exit; }
if (aviso > 0) { aviso--; exit; }

var oPlayer = obj_jugador;
if (instance_exists(oPlayer)) {
    var _px = oPlayer.x;
    var _py = (oPlayer.bbox_top + oPlayer.bbox_bottom) / 2;

    if (_px > z_x1 && _px < z_x2 && _py > z_y1 && _py < z_y2) {
        with (oPlayer) {
            var _vuela = is_transformed && (transform_type == 3 || transform_type == 4 || transform_type == 5
                      || transform_type == 7 || transform_type == 8 || transform_type == 9 || transform_type == 10);

            if (other.tipo < 0) {
                // --- LIGERA: flota, salta alto y cae despacio ---
                grav_mult  = other.grav_ligera;
                salto_mult = other.salto_ligera;
                vel_mult   = other.vel_ligera;
                if (_vuela) viento_y = -2;
                else if (vsp > 2.5) vsp = 2.5;   // límite de caída
            } else {
                // --- PESADA: salto corto, cae rápido y camina lento ---
                grav_mult  = other.grav_pesada;
                salto_mult = other.salto_pesada;
                vel_mult   = other.vel_pesada;
                if (_vuela) viento_y = 2.4;
            }
        }
    }
}