timer--;
if (timer <= 0) { instance_destroy(); exit; }
if (aviso > 0) { aviso--; exit; }

var oPlayer = obj_jugador;
if (instance_exists(oPlayer)) {
    var _px = oPlayer.x;
    var _py = (oPlayer.bbox_top + oPlayer.bbox_bottom) / 2;

    if (_px > z_x1 && _px < z_x2 && _py > z_y1 && _py < z_y2) {
        var _v = (tipo < 0) ? -1.1 : 1.5;   // ligera sube, pesada baja
        with (oPlayer) viento_y = _v;
    }
}