timer--;
if (timer <= 0) { instance_destroy(); exit; }

if (aviso > 0) { aviso--; exit; }

var oPlayer = obj_jugador;
if (instance_exists(oPlayer)) {
    var _dentro = oPlayer.x > x - ancho / 2 && oPlayer.x < x + ancho / 2
               && oPlayer.y > y_top && oPlayer.y < y_bot;

    if (_dentro) {
        with (oPlayer) {
            // Contrarresta la gravedad y la deja flotando hacia arriba (sin cortar un salto)
            if (vsp > -3.5) vsp = max(vsp - 0.55, -3.5);
        }
    }
}