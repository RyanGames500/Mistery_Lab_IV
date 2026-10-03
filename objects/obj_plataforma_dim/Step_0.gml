if (aviso > 0) {
    aviso--;
    if (aviso <= 0) {
        if (objetivo_oculta) {
            y = y_base + 20000;
            oculta = true;
        } else {
            y = y_base;
            // No reaparece encima de Gaby: lo reintenta
            if (place_meeting(x, y, obj_jugador)) {
                y = y_base + 20000;
                aviso = 10;
            } else {
                oculta = false;
            }
        }
    }
}