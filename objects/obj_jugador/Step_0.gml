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

if (is_poisoned) {
    poison_timer--;
    if (poison_timer <= 0) {
        is_poisoned = false;
        image_blend = c_white; 
    } else {
        image_blend = c_green; 
    }
}

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
    if (is_attacking) { 
        mask_index = sprGaby_idle_mask; 
    } 
    else {
        if (is_transformed) {
            if (transform_type == 1) {
                mask_index = sprBalon_idle; 
            } 
            else if (transform_type == 3) {
                mask_index = spr_gaby_globo; 
            } 
            else if (transform_type == 4 || transform_type == 5) {
                mask_index = sprBalon_idle; 
            }
            else {
                mask_index = sprBalon_idle; 
            }
        } else {
            mask_index = sprGaby_idle_mask;
        }
    }

    if (coyote_timer > 0) coyote_timer--;
    if (jump_buffer > 0) jump_buffer--;
    if (_is_grounded) coyote_timer = coyote_max;
    if (key_jump) jump_buffer = buffer_max;

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

    if (is_transformed && transform_type == 3) {
        if (!is_dashing) {
            if (move != 0) {
                hsp += move * _aceleracion;
                hsp = clamp(hsp, -current_spd, current_spd);
            } else {
                hsp = lerp(hsp, 0, _friccion);
                if (abs(hsp) < 0.1) hsp = 0;
            }
        }
        
        var _key_up   = keyboard_check(vk_up)   || gamepad_button_check(0, gp_padu) || keyboard_check(ord("W"));
        var _key_down = keyboard_check(vk_down) || gamepad_button_check(0, gp_padd) || keyboard_check(ord("S"));
        var _vmove = _key_down - _key_up; 
        
        if (_vmove != 0) {
            vsp = lerp(vsp, _vmove * 2.5, 0.15);
        } else {
            if (!is_dashing) {
                var _flote_bajo = (sin(current_time * 0.005) * 0.4) + 0.3; 
                vsp = lerp(vsp, _flote_bajo, 0.1);
            }
        }
        
        if (place_meeting(x, y - 5, obj_wall)) {
            if (vsp < 0) vsp = 0;
        }
    } 
    else if (is_transformed && transform_type == 4) {
        var _dir_x = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
        var _dir_y = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));
        var _nube_spd = 7; 
        
        if (_dir_x != 0) {
            hsp = lerp(hsp, _dir_x * _nube_spd, 0.2);
            image_xscale = sign(_dir_x) * abs(image_xscale);
        } else {
            hsp = lerp(hsp, 0, 0.15);
        }
        
        if (_dir_y != 0) {
            vsp = lerp(vsp, _dir_y * _nube_spd, 0.2);
        } else {
            vsp = lerp(vsp, 0, 0.15); 
        }
        
        var _viento = instance_place(x, y, obj_ventilador);
        if (_viento != noone) {
            vsp = -12; 
        }
        
        if (nube_cooldown > 0) nube_cooldown--;
        
        if (key_atk_z && !is_poisoned && !nube_fase_active && nube_cooldown <= 0) {
            nube_fase_active = true;
            nube_fase_timer = 180; 
            nube_cooldown = 300;   
        }
        
        if (nube_fase_active) {
            nube_fase_timer--;
            if (nube_fase_timer <= 0) {
                nube_fase_active = false;
            }
        }
    }
    else if (is_transformed && transform_type == 5) {
        var _dir_x = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
        var _dir_y = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));
        var _bee_spd = 4.5; 
        var _zigzag = sin(current_time * 0.02) * 1.5; 
        
        if (_dir_x != 0) {
            hsp = lerp(hsp, (_dir_x * _bee_spd) + _zigzag, 0.15);
            image_xscale = sign(_dir_x) * abs(image_xscale);
        } else {
            hsp = lerp(hsp, 0, 0.15);
        }
        
        if (_dir_y != 0) {
            vsp = lerp(vsp, _dir_y * _bee_spd, 0.15);
        } else {
            vsp = lerp(vsp, 0, 0.15); 
        }
    }
    else {
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

        if (coyote_timer > 0 && jump_buffer > 0) {
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
        if (key_atk_z && !is_poisoned && !is_dashing) {
            is_dashing = true;
            jump_buffer = 25; 
        }
        
        if (is_dashing) {
            hsp = (image_xscale >= 0 ? 1 : -1) * 12; 
            vsp = lerp(vsp, 0, 0.2); 
            jump_buffer--;
            
            var _enemy_hit = instance_place(x + hsp, y, obj_enemy_parent);
            if (_enemy_hit != noone) {
                with (_enemy_hit) {
                    instance_destroy();
                }
            }
            
            if (jump_buffer <= 0) {
                is_dashing = false;
            }
        }
        
        if (key_atk_x && !is_poisoned) {
            var _spawn_x = x + ((image_xscale >= 0 ? 1 : -1) * 15) + (hsp * 2);
            var _misil = instance_create_layer(_spawn_x, (y + 15) + (vsp * 2), "Instances", obj_misil_globo);
            _misil.hsp = (image_xscale >= 0 ? 1 : -1) * 2;
        }
    }
    else if (is_transformed && transform_type == 4) {
        if (key_atk_x && !is_poisoned) {
            var _spawn_x = x + (hsp * 2);
            var _rayo = instance_create_layer(_spawn_x, (y - 32) + (vsp * 2), "Platform_Points", obj_rayo_nube);
            _rayo.direction = (image_xscale >= 0) ? 0 : 180;
            _rayo.image_xscale = image_xscale;
            
            instance_create_layer(0, 0, "Platform_Points", obj_relampago_flash); 
            screen_shake(3);
        }
    }
    else if (is_transformed && transform_type == 5) {
        if (key_atk_z && !is_poisoned) {
            var _dir_ataque = (image_xscale >= 0) ? 1 : -1;
            var _spawn_x = x + (_dir_ataque * 20) + (hsp * 2);
            var _aguijon = instance_create_layer(_spawn_x, y + (vsp * 2), "Instances", obj_aguijon_abeja);
            with (_aguijon) {
                image_xscale = other.image_xscale;
            }
        }
        
        if (key_atk_x && !is_poisoned) {
            var _dir_miel = (image_xscale >= 0) ? 1 : -1;
            var _spawn_x = x + (_dir_miel * 12) + (hsp * 2);
            var _miel = instance_create_layer(_spawn_x, (y - 25) + (vsp * 2), "Instances", obj_miel_abeja);
            _miel.hsp = (_dir_miel * 4.5) + (hsp * 0.8); 
            _miel.vsp = -2.5 + (vsp * 0.5); 
            _miel.image_xscale = image_xscale;
        }
    }
    else {
        if (key_atk_z && !is_attacking && !is_poisoned) { current_weapon = 1; is_attacking = true; is_shooting = false; image_index = 0; }
        if (key_atk_x && !is_attacking && !is_poisoned) { current_weapon = 2; is_attacking = true; is_shooting = true; bullet_spawned = false; image_index = 0; }
    }
} 

var _finalMoveX = hsp;
var _finalMoveY = vsp;

var _platform = noone;

if (!(is_transformed && (transform_type == 4 || transform_type == 5)) && !(is_transformed && transform_type == 3 && is_dashing)) {
    _platform = instance_place(x, y + max(1, _finalMoveY + 2), obj_plataforma_movil);
    if (!_platform) _platform = instance_place(x, y + max(1, _finalMoveY + 2), obj_plataforma_caida);
    if (!_platform) _platform = instance_place(x, y + max(1, _finalMoveY + 2), obj_plataforma_atravesable);
}

if (_platform && _finalMoveY >= 0 && bbox_bottom <= _platform.bbox_top + 4) {
    while (!place_meeting(x, y + sign(_finalMoveY), _platform)) {
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
    
    if (variable_instance_exists(_platform, "moveX")) {
        _finalMoveX += _platform.moveX;
        _finalMoveY += _platform.moveY;
    }
}

if (!nube_fase_active && place_meeting(x + _finalMoveX, y, obj_wall)) {
    while (!place_meeting(x + sign(_finalMoveX), y, obj_wall)) x += sign(_finalMoveX);
    _finalMoveX = 0;
}

if (!nube_fase_active && place_meeting(x, y + _finalMoveY, obj_wall)) {
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

if (!nube_fase_active && place_meeting(x, y, obj_wall)) {
    y -= 1;
}
if (!nube_fase_active && place_meeting(x, y, obj_wall)) {
    x -= sign(hsp != 0 ? hsp : image_xscale);
}

if (!is_hit && !is_dead) {
    if (is_attacking && !is_shooting && !melee_spawned) {
        if (floor(image_index) >= 1) {
            var _spawn_x = x + ((0 * image_xscale)) + (hsp * 2);
            var _hitbox = instance_create_layer(_spawn_x, (y - 25) + (vsp * 2), "Instances", obj_hitbox);
            with (_hitbox) { image_xscale = 1.5 * other.image_xscale; image_yscale = 0.5; }
            melee_spawned = true;
        }
    }

    if (is_shooting && !bullet_spawned) {
        if (floor(image_index) >= 2) {
            if (global.ammo > 0) {
                screen_shake(1);
                var _spawn_x = x + (hsp * 2);
                var _bullet = instance_create_layer(_spawn_x, (y - 35) + (vsp * 2), "Instances", obj_bullet);
                _bullet.direction = (image_xscale > 0) ? 0 : 180;
                _bullet.image_xscale = image_xscale;
                if(room != rm_main && room != rm_galery_seccion1 && room != rm_galery_seccion2) {
                    global.ammo -= 1;
                }
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
    if (is_transformed && (transform_type == 3 || transform_type == 4 || transform_type == 5) && abs(hsp) > 0.1) {
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
            } else if (transform_type == 4) {
                sprite_index = spr_gaby_nube; 
            } else if (transform_type == 5) {
                sprite_index = spr_gaby_abeja; 
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
        sprite_index = spr_Gaby_hit_shots; // Ajustado por coherencia si aplica
    } else {
        sprite_index = spr_Gaby_hit;
    }
    if (image_index >= image_number - 1) { is_hit = false; }
}

if (invincible) {
    if (current_time % 20 < 10) {
        image_alpha = 0.5;
    } else {
        image_alpha = 1;
    }
} else {
    if (!(is_transformed && transform_type == 4 && nube_fase_active)) {
        image_alpha = 1;
    }
}

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