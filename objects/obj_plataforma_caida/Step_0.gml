if (global.pausado) {
    exit;
}

if (place_meeting(x, y - 1, obj_jugador) && !trigger) {
    trigger = true;
    alarm[0] = 30; // 30 frames = 0.5 segundos
}