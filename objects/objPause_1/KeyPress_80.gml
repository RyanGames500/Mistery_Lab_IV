pause = !pause;

if (pause) {
    audio_pause_all();
    selected = 0; 
} else {
    if (surface_exists(pauseSurface)) {
        surface_free(pauseSurface);
    }
    instance_activate_all();
    audio_resume_all();
}