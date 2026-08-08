var _rango_audible = 300; 
var _distancia = point_distance(x, y, obj_jugador.x, obj_jugador.y);
var _es_cerca = (_distancia < _rango_audible); 
var _volumen = clamp(1 - (_distancia / _rango_audible), 0, 1);

if (hp <= 0 && estado != "MUERTE") {
    estado = "MUERTE";
    audio_stop_all();
}

if (estado != "MUERTE" && estado != "HIT") {
    timer++; 
}

switch (estado) {
    case "IDLE":
        sprite_index = sprCandy_idle;
        if (timer >= tiempo_idle) {
            estado = "PREPARA";
            estado_anterior = "PREPARA";
            timer = 0;
        }
    break;

    case "PREPARA":
        sprite_index = sprCandy_prepara_ataque;
        if (image_index >= image_number - 1) {
            estado = "ATAQUE";
            estado_anterior = "ATAQUE";
            timer = 0; 
        }
    break;

    case "ATAQUE":
    sprite_index = sprCandy_ataca;
    if (_es_cerca) screen_shake(0.5);

    if (_es_cerca) {
        if (snd_inst == -1 || !audio_is_playing(snd_inst)) {
            snd_inst = audio_play_sound(snd_giro, 10, true);
        }
        audio_sound_gain(snd_inst, _volumen, 0); 
    } 
    // Si está lejos
    else {
        if (snd_inst != -1 && audio_is_playing(snd_inst)) {
            audio_stop_sound(snd_inst);
            snd_inst = -1;
        }
    }

    if (timer >= tiempo_ataque) {
        if (snd_inst != -1) { audio_stop_sound(snd_inst); snd_inst = -1; }
        estado = "MAREADA";
        estado_anterior = "MAREADA";
        timer = 0; 
    }
    break;

    case "MAREADA":
        sprite_index = sprCandy_mareada;
        if (_es_cerca) {
            if (snd_inst == -1 || !audio_is_playing(snd_inst)) {
                snd_inst = audio_play_sound(snd_mareo, 10, true);
            }
            audio_sound_gain(snd_inst, _volumen, 0);
        } else {
            if (snd_inst != -1 && audio_is_playing(snd_inst)) {
                audio_stop_sound(snd_inst);
                snd_inst = -1;
            }
        }
        
        if (timer >= tiempo_mareada) {
            if (snd_inst != -1) { 
                audio_stop_sound(snd_inst); 
                snd_inst = -1; 
            }
            estado = "IDLE";
            estado_anterior = "IDLE";
            timer = 0;
        }
    break;
    
    case "HIT":
        sprite_index = sprCandy_hit;
        if (image_index >= image_number - 1) {
            estado = estado_anterior;
        }
    break;

    case "MUERTE":
        sprite_index = sprCandy_die;
        if (floor(image_index) == 12 && !snd_played) {
            audio_play_sound(snd_dead, 10, false);
            snd_played = true;
        }
        if (image_index >= image_number - 1) instance_destroy();
    break;
}

mask_index = (estado == "ATAQUE") ? sprCandy_ataca_mask : sprCandy_mask;
if (estado != "MAREADA" && audio_is_playing(snd_mareo)) {
    audio_stop_sound(snd_mareo);
}