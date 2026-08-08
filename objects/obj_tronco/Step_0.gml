switch (estado) {
    case "ESPERANDO":
        x = startX;
        cronometro++;
        if (cronometro >= tiempo_espera) {
            cronometro = 0;
            estado = "ATACANDO";
        }
        break;
        
    case "ATACANDO":
        var _velocidad = 4;
        var _dir = sign(targetX - startX);
        if (_dir == 0) _dir = 1;
        
        var _movimiento = _velocidad * _dir;
        
        if (place_meeting(x + _movimiento, y, obj_jugador) || place_meeting(x, y - 1, obj_jugador)) {
            with (obj_jugador) {
                if (!is_dead) {
                    if (place_meeting(x, y + 1, other)) {
                        x += _movimiento;
                    } else {
                        x += _movimiento;
                    }
                }
            }
        }
        
        x += _movimiento;
        
        if ((_dir > 0 && x >= targetX) || (_dir < 0 && x <= targetX)) {
            x = targetX;
            cronometro = 0;
            estado = "ESPERando_pausa";
        }
        break;
        
    case "ESPERando_pausa":
        cronometro++;
        if (cronometro >= 50) {
            cronometro = 0;
            estado = "REGRESANDO";
        }
        break;
        
    case "REGRESANDO":
        var _velocidad = 4;
        var _dir = sign(startX - targetX);
        if (_dir == 0) _dir = -1;
        
        var _movimiento = _velocidad * _dir;
        
        if (place_meeting(x + _movimiento, y, obj_jugador) || place_meeting(x, y - 1, obj_jugador)) {
            with (obj_jugador) {
                if (!is_dead) {
                    if (place_meeting(x, y + 1, other)) {
                        x += _movimiento;
                    } else {
                        x += _movimiento;
                    }
                }
            }
        }
        
        x += _movimiento;
        
        if ((_dir > 0 && x >= startX) || (_dir < 0 && x <= startX)) {
            x = startX;
            cronometro = 0;
            estado = "ESPERANDO";
        }
        break;
}