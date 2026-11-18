if (FX_SLOWMO) {
    game_set_speed(FX_SLOWMO_FPS, gamespeed_fps);
    alarm[1] = FX_SLOWMO_STEPS;
} else {
    game_set_speed(fps_original, gamespeed_fps);
    fase = 2;
}