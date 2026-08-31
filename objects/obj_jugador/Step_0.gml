if (global.pausado) {
    exit;
}

if (can_move == false) {
    exit;
}

if (is_dead) {
    hsp = 0; 
    
    if (!arma_soltada && !is_transformed) {
        arma_soltada = true; 
        if (current_weapon > 0) {
            var _arma_visual = instance_create_layer(x, y - 20, "Platform_Points", obj_arma_muerte);
            with (_arma_visual) {
                if (other.current_weapon == 1) {
                    sprite_index = spr_Gaby_matafuegos;
                } else {
                    sprite_index = sprGaby_pistola; 
                }
                image_xscale = other.image_xscale * 1.5;
                image_yscale = 1.5;
            }
        }
    }

    if (death_type == "hoyo_negro") {
        vsp = 0;
        if (image_xscale < 0) image_xscale = abs(image_xscale);
        image_angle += 15; 
        image_xscale = max(0, image_xscale - 0.05);
        image_yscale = max(0, image_yscale - 0.05);
        if (image_xscale <= 0) {
            if (!instance_exists(obj_game_over)) {
                instance_create_layer(0, 0, "Instances", obj_game_over);
            }
            visible = false;
        }
        exit;
    } else {
        vsp += grv;
        if (place_meeting(x, y + vsp, obj_wall)) {
            while (!place_meeting(x, y + sign(vsp), obj_wall)) {
                y += sign(vsp);
            }
            vsp = 0;
        }
        y += vsp;
        sprite_index = spr_Gaby_die_normal;
        if (place_meeting(x, y + 1, obj_wall)) {
            if (image_index >= image_number - 1) { 
                image_index = image_number - 1; 
                image_speed = 0; 
                if (!instance_exists(obj_game_over)) {
                    instance_create_layer(0, 0, "Instances", obj_game_over);
                }
            }
        }
        exit;
    }
}

//teclado / TACTIL
scrInputs();

var _is_grounded = place_meeting(x, y + 1, obj_wall) || 
                   place_meeting(x, y + 1, obj_hielo) || 
                   (place_meeting(x, y + 1, obj_plataforma_movil) && vsp >= 0) || 
                   (place_meeting(x, y + 1, obj_plataforma_caida) && vsp >= 0) ||
                   (place_meeting(x, y + 1, obj_plataforma_atravesable) && vsp >= 0);

if (is_caught) {
    hsp = 0;
    vsp = 0;
    if (current_weapon == 0) {
        sprite_index = spr_Gaby_enredado;         
    } else if (current_weapon == 1) {
        sprite_index = spr_Gaby_enre_matafueg;  
    } else {
        sprite_index = spr_Gaby_enredado_pistola; 
    }
    exit; 
}

if (is_transforming) {
    hsp = 0;
    vsp += grv;
    if (_is_grounded) {
        vsp = 0;
    }
    y += vsp;
    exit; 
}

//si estas bajo el efecto de las flechas no puedes atacar
if (is_poisoned) {
    poison_timer--;
    if (poison_timer <= 0) {
        is_poisoned = false;
        image_blend = c_white; 
    } else {
        image_blend = c_green; 
    }
}

//si estas bajo el efecto del gs los controles se sinvierten
if (controls_inverted) {
    invert_timer--;
    if (invert_timer <= 0) {
        controls_inverted = false;
        image_blend = c_white; 
    } else {
        image_blend = c_purple; 
    }
}

if (!is_hit) {
    if (is_attacking) { mask_index = sprGaby_idle_mask; } 
    else { mask_index = is_transformed ? sprBalon_idle : sprGaby_idle_mask; }

    if (coyote_timer > 0) coyote_timer--;
    if (jump_buffer > 0) jump_buffer--;
    if (_is_grounded) coyote_timer = coyote_max;
    if (key_jump) jump_buffer = buffer_max;

//aqui hiban las inputs--

    var move = 0;

    if (controls_inverted) {
        move = key_left - key_right; 
    } else {
        move = key_right - key_left; 
    }
    
    if (is_attacking) move = 0;
    if (is_dashing) {
        
        if ((image_xscale > 0 && key_left) || (image_xscale < 0 && key_right)) {
            hsp = lerp(hsp, 0, 0.3); 
            if (abs(hsp) < 0.5) is_dashing = false; 
        }
        move = 0;
    }
    current_spd = key_run ? run_spd : walk_spd;

    var _en_telarana = place_meeting(x, y, obj_tela_arana);
    if (_en_telarana) {
        current_spd = current_spd * 0.4;
    }

    if (place_meeting(x, y, obj_lodo)) {
        if (!(is_transformed && transform_type == 1)) {
            current_spd = current_spd * 0.5;
        }
    }

    var _en_hielo = place_meeting(x, y + 1, obj_hielo);
    var _friccion = (is_dashing) ? 0.02 : (_en_hielo ? 0.05 : 0.5); 
    var _aceleracion = _en_hielo ? 0.02 : 0.4; 

    // --- LÓGICA DE MOVIMIENTO BASE Y TRANSFORMACIONES ---
    if (is_transformed && transform_type == 3) {
        // MOVIMIENTO TF3: GLOBO AEROSTÁTICO
        vsp = 0;
        
        if (move != 0) {
            hsp += move * _aceleracion;
            hsp = clamp(hsp, -current_spd, current_spd);
        } else {
            hsp = lerp(hsp, 0, _friccion);
            if (abs(hsp) < 0.1) hsp = 0;
        }
        
        // Flotación relativa al piso sin errores
        var _suelo_abajo = collision_line(x, y, x, y + 250, obj_wall, false, true);
        if (_suelo_abajo != noone) {
            var _distancia_piso = _suelo_abajo.y - y;
            if (_distancia_piso > 90) {
                vsp = 1; 
            } else if (_distancia_piso < 70) {
                vsp = -1; 
            } else {
                vsp = sin(current_time * 0.005) * 0.5; 
            }
        }
        
    } else {
        // MOVIMIENTO NORMAL
        if (move != 0) {
            hsp += move * _aceleracion;
            hsp = clamp(hsp, -current_spd, current_spd);
        } else {
            hsp = lerp(hsp, 0, _friccion);
            if (abs(hsp) < 0.1) {
                hsp = 0;
                is_dashing = false; 
            }
        }

        vsp += grv;

        if (coyote_timer > 0 && jump_buffer > 0) 
        {
            var _salto_base = is_transformed ? jump_spd_ball : jump_spd_standard;
            if (_en_telarana) {
                vsp = _salto_base * 0.5;
            } else {
                vsp = _salto_base;
            }
            coyote_timer = 0; 
            jump_buffer = 0;
        }
    }

    // --- ACCIONES SEGÚN TRANSFORMACIÓN ---
    if (is_transformed && transform_type == 1) {
        if (key_atk_z && !is_poisoned) {
            var _dir = (image_xscale >= 0) ? 1 : -1;
            hsp = _dir * (run_spd * 1.5);
            is_dashing = true;
        }
        
        if (key_atk_x && !is_poisoned && !_is_grounded) {
            hsp = 0;
            vsp = 0;             
            slam_timer = 15;      
            slam_active = true;
            is_dashing = false;
            flash_timer = 3;  
            var _dir_actual = sign(image_xscale != 0 ? image_xscale : 1);
            image_xscale = 0.7 * _dir_actual;
        }

        if (slam_timer > 0) {
            vsp = 0;          
            slam_timer--;
            hsp = 0; 
            if (slam_timer == 0) {
                vsp = 18;     
                var _dir_actual = sign(image_xscale != 0 ? image_xscale : 1);
                image_xscale = 0.5 * _dir_actual;
            }
        }
        
        if (flash_timer > 0) {
            flash_timer--;
        }        
    } 
    else if (is_transformed && transform_type == 3) {
        //GLOBO AEROSTATICO
        if (key_atk_z && !is_poisoned && !is_dashing) {
            is_dashing = true;
            jump_buffer = 25; 
        }
        
        if (is_dashing) {
            hsp = (image_xscale >= 0 ? 1 : -1) * 12; // Velocidad de envestida fuerte
            vsp = 0;
            jump_buffer--;
            
            // Matar o golpear enemigos en la trayectoria del dash
            var _enemy_hit = instance_place(x + hsp, y, obj_enemy_parent);
            if (_enemy_hit != noone) {
                with (_enemy_hit) {
                    //bajar vida
                    instance_destroy();
                }
            }
            
            if (jump_buffer <= 0) {
                is_dashing = false;
            }
        }
        
        if (key_atk_x && !is_poisoned) {
            var _misil = instance_create_layer(x, y + 15, "Instances", obj_misil_globo);
            _misil.hsp = (image_xscale >= 0 ? 1 : -1) * 2;
        }
    }
    else {
        if (key_atk_z && !is_attacking && !is_poisoned) { current_weapon = 1; is_attacking = true; is_shooting = false; image_index = 0; }
        if (key_atk_x && !is_attacking && !is_poisoned) { current_weapon = 2; is_attacking = true; is_shooting = true; bullet_spawned = false; image_index = 0; }
    }
} 

//colicion con plataformas que se mueven (Con rebote integrado para la pelota)
var _finalMoveX = hsp;
var _finalMoveY = vsp;

var _platform = instance_place(x, y + max(1, _finalMoveY + 2), obj_plataforma_movil);
if (!_platform) _platform = instance_place(x, y + max(1, _finalMoveY + 2), obj_plataforma_caida);
if (!_platform) _platform = instance_place(x, y + max(1, _finalMoveY + 2), obj_plataforma_atravesable);

if (_platform && _finalMoveY >= 0 && bbox_bottom <= _platform.bbox_top + 4) {
    while (!place_meeting(x, y + sign(_finalMoveY), _platform)) {
        y += sign(_finalMoveY);
    }
    
    // Si somos pelota y vamos cayendo, aplicamos el rebote en lugar de frenar en seco
    if (is_transformed && transform_type == 1 && _finalMoveY > 0) {
        vsp = -vsp * bounce_factor;
        if (abs(vsp) < 2) vsp = 0;
        _finalMoveY = 0;
        
        if (slam_active) {
            screen_shake(6); 
            slam_active = false; 
        }
    } else {
        _finalMoveY = 0;
        vsp = 0;
    }
    
    if (variable_instance_exists(_platform, "moveX")) {
        _finalMoveX += _platform.moveX;
        _finalMoveY += _platform.moveY;
    }
}

if (place_meeting(x + _finalMoveX, y, obj_wall)) {
    while (!place_meeting(x + sign(_finalMoveX), y, obj_wall)) x += sign(_finalMoveX);
    _finalMoveX = 0;
}

if (place_meeting(x, y + _finalMoveY, obj_wall)) {
    while (!place_meeting(x, y + sign(_finalMoveY), obj_wall)) {
        y += sign(_finalMoveY);
    }
    
    if (is_transformed && transform_type == 1 && _finalMoveY > 0) {
        vsp = -vsp * bounce_factor;
        if (abs(vsp) < 2) vsp = 0;
        _finalMoveY = 0;
        
        if (slam_active) {
            screen_shake(6); 
            slam_active = false; 
        }
    } else {
        _finalMoveY = 0;
        vsp = 0;
    }
}

x += _finalMoveX;
y += _finalMoveY;

// Sistema anti-atasco seguro
if (place_meeting(x, y, obj_wall)) {
    y -= 1;
}
if (place_meeting(x, y, obj_wall)) {
    x -= sign(hsp != 0 ? hsp : image_xscale);
}

if (!is_hit && !is_dead) {
    if (is_attacking && !is_shooting && !melee_spawned) {
        if (floor(image_index) >= 1) {
            var _hitbox = instance_create_layer(x + (15 * image_xscale), y - 25, "Instances", obj_hitbox);
            with (_hitbox) { image_xscale = 1.5 * other.image_xscale; image_yscale = 0.5; }
            melee_spawned = true;
        }
    }

    if (is_shooting && !bullet_spawned) {
        if (floor(image_index) >= 2) {
            if (global.ammo > 0) {
                screen_shake(1);
                var _bullet = instance_create_layer(x, y-35, "Instances", obj_bullet);
                _bullet.direction = (image_xscale > 0) ? 0 : 180;
                _bullet.image_xscale = image_xscale;
                if(room != rm_main && room != rm_galery_seccion1 && room != rm_galery_seccion2)
                {
                global.ammo -= 1;}
                }
                bullet_spawned = true;
        }
    }

    if (hsp != 0 && !is_attacking && !is_transformed) {
        image_xscale = sign(hsp);
    }
    if (is_transformed && transform_type == 1 && abs(hsp) > 0.1) {
        if (hsp > 0) image_xscale = abs(image_xscale);
        if (hsp < 0) image_xscale = -abs(image_xscale);
    }
    if (is_transformed && transform_type == 3 && abs(hsp) > 0.1) {
        image_xscale = sign(hsp) * abs(image_xscale);
    }

    if (is_attacking) {
        if (is_shooting) {
            sprite_index = (!_is_grounded) ? sprite_atk_jump : sprite_atk;
        } else {
            sprite_index = (!_is_grounded) ? sprite_melee_air : sprite_melee_ground;
        }
    } else {
        if (is_transformed) {
            if (transform_type == 1) {
                sprite_index = (_is_grounded) ? (hsp != 0 ? sprBalon_run : sprBalon_idle) : sprBalon_idle;
            } else if (transform_type == 2) {
                sprite_index = (_is_grounded) ? (hsp != 0 ? sprGabyCristal_run : sprGabyCristal_idle) : sprGabyCristal_jump;
            } else if (transform_type == 3) {
                sprite_index = spr_gaby_globo;
            }
        } else {
            if (current_weapon == 1) {
                sprite_index = (_is_grounded) ? (hsp != 0 ? sprGaby_walk : sprGaby_idle) : (vsp < 0 ? spr_jump_up : spr_jump_fall);
            } else {
                sprite_index = (_is_grounded) ? (hsp != 0 ? sprGaby_walk_shot : sprGaby_idle_shot) : (vsp < 0 ? spr_jump_up_shot : spr_jump_fall_shot);
            }
        }
    }
} else {
    hsp = lerp(hsp, 0, 0.2);
    vsp += grv;
    if (current_weapon == 1) {
        sprite_index = spr_Gaby_hit;          
    } else if (current_weapon == 2) {
        sprite_index = spr_Gaby_hit_shot;
    } else {
        sprite_index = spr_Gaby_hit;
    }
    if (image_index >= image_number - 1) { is_hit = false; }
}

//invensibilidad
if (invincible) {
    if (current_time % 20 < 10) {
        image_alpha = 0.5;
    } else {
        image_alpha = 1;
    }
} else {
    image_alpha = 1;
}

//teletransporte
var _pad = instance_place(x, y, obj_pad);
if (_pad != noone) {
    if (keyboard_check_pressed(ord("Z"))) {
        with (obj_destino) {
            if (index == _pad.index) {
                obj_jugador.x = x;
                obj_jugador.y = y;
                break; 
            }
        }
    }
}

// DEFORMACION DE TF: PELOTA
if (is_transformed && transform_type == 1) {
    if (!_is_grounded) {
        if (vsp > 2) {
            image_yscale = lerp(image_yscale, 1.3, 0.2);
            image_xscale = lerp(image_xscale, 0.8 * (image_xscale >= 0 ? 1 : -1), 0.2);
        } else if (vsp < -2) {
            image_yscale = lerp(image_yscale, 1.2, 0.2);
            image_xscale = lerp(image_xscale, 0.9 * (image_xscale >= 0 ? 1 : -1), 0.2);
        } else {
            image_yscale = lerp(image_yscale, 1, 0.2);
            image_xscale = lerp(image_xscale, 1 * (image_xscale >= 0 ? 1 : -1), 0.2);
        }
    } else {
        if (abs(hsp) > 1) {
            image_yscale = lerp(image_yscale, 0.8, 0.2);
            image_xscale = lerp(image_xscale, 1.2 * sign(hsp), 0.2);
        } else {
            image_yscale = lerp(image_yscale, 1, 0.2);
            image_xscale = lerp(image_xscale, 1 * (image_xscale >= 0 ? 1 : -1), 0.2);
        }
    }
}