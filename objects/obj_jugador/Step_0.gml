if (!variable_instance_exists(id, "tf_cooldown")) tf_cooldown = 0;
if (!variable_instance_exists(id, "arpia_picada")) arpia_picada = 0;
if (!variable_instance_exists(id, "escala_tf")) escala_tf = 0.6;
if (!variable_instance_exists(id, "medusa_zcd"))    medusa_zcd = 0;
if (!variable_instance_exists(id, "medusa_xcd"))    medusa_xcd = 0;
if (!variable_instance_exists(id, "medusa_lock"))   medusa_lock = 0;
if (!variable_instance_exists(id, "muerte_fase"))   muerte_fase = 0;
if (!variable_instance_exists(id, "muerte_t"))      muerte_t = 0;
if (!variable_instance_exists(id, "muerte_espera")) muerte_espera = 0;
if (!variable_instance_exists(id, "esc_base")) esc_base = 1;
if (global.pausado) {
    exit;
}

if (global.cinematica) {
    hsp = 0;
    exit;
}

if (can_move == false) {
    exit;
}

if (is_dead) {
    hsp = 0; 
    
    if (!arma_soltada && !is_transformed && transform_type == 0) {
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

    if (is_transformed && transform_type == 10 && death_type != "hoyo_negro") {
        if (muerte_fase == 0) {
            muerte_fase = 1;
            muerte_t = 0;
            muerte_espera = 10;
            is_hit = false;
            vsp = 0;
            screen_shake(6);
        }

        if (muerte_fase == 1) {
            globos_medusa_step();

            if (muerte_espera > 0) {
                muerte_espera--;
            } else {
                muerte_t++;
                if (muerte_t % 5 == 0) {
                    if (!globos_medusa_reventar()) {
                        muerte_fase = 2;
                        arma_soltada = true;
                        is_transformed = false;
                        transform_type = 0;
                        image_yscale = 1;
                        image_xscale = (image_xscale >= 0) ? 1 : -1;
                        mask_index = sprGaby_idle_mask;
                        sprite_index = spr_Gaby_die_normal;
                        image_index = 4;
                        image_speed = 1;
                        vsp = -2;
                        y -= 6;
                        fx_pop_globo(x, y - 20, 14);
                    }
                }
            }
            exit;
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
        image_xscale = (image_xscale >= 0) ? 1 : -1;
        image_yscale = 1;

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
esc_base = tf_escala((is_transformed || is_transforming) ? transform_type : 0);
var _squash = (is_transformed && !is_transforming && (transform_type == 1 || transform_type == 6));
if (!_squash) {
    image_xscale = ((image_xscale >= 0) ? 1 : -1) * esc_base;
    image_yscale = esc_base;
}

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
            if (transform_type == 1 || transform_type == 6) {
                mask_index = sprBalon_idle; 
            } 
            else if (transform_type == 3) {
                mask_index = spr_gaby_globo; 
            } 
            else if (transform_type == 4 || transform_type == 5 || transform_type == 7 || transform_type == 9 || transform_type == 10 || transform_type == 11 || transform_type == 12) {
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
    current_spd *= vel_mult;

    var _en_telarana = place_meeting(x, y, obj_tela_arana);
    if (_en_telarana) {
        current_spd = current_spd * 0.4;
    }

    if (place_meeting(x, y, obj_lodo)) {
        if (!(is_transformed && (transform_type == 1 || transform_type == 6))) {
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
    else if (is_transformed && transform_type == 7) {
        var _dir_x = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
        var _dir_y = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));
        var _sucubo_spd = 4.0; 
        
        if (_dir_x != 0) {
            hsp = lerp(hsp, _dir_x * _sucubo_spd, 0.2);
            image_xscale = sign(_dir_x) * abs(image_xscale);
        } else {
            hsp = lerp(hsp, 0, 0.15);
        }
        
        if (_dir_y != 0) {
            vsp = lerp(vsp, _dir_y * _sucubo_spd, 0.2);
        } else {
            vsp = lerp(vsp, 0, 0.15); 
        }
    }
    else if (is_transformed && transform_type == 9) {
        var _dir_x = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
        var _dir_y = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));
        var _avion_spd = 5.5; 
        
        if (_dir_x != 0) {
            hsp = lerp(hsp, _dir_x * _avion_spd, 0.2);
            image_xscale = sign(_dir_x) * abs(image_xscale);
        } else {
            hsp = lerp(hsp, 0, 0.15);
        }
        
        if (_dir_y != 0) {
            vsp = lerp(vsp, _dir_y * _avion_spd, 0.2);
        } else {
            vsp = lerp(vsp, 0, 0.15); 
        }
    }
    else if (is_transformed && transform_type == 10) {
        if (medusa_zcd > 0)  medusa_zcd--;
        if (medusa_xcd > 0)  medusa_xcd--;
        if (medusa_lock > 0) medusa_lock--;

        var _dir_x = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
        var _dir_y = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));
        if (medusa_lock > 0) { _dir_x = 0; _dir_y = 0; }
        var _medusa_spd = 4.5;

        if (_dir_x != 0) {
            hsp = lerp(hsp, _dir_x * _medusa_spd, 0.2);
            image_xscale = sign(_dir_x) * abs(image_xscale);
        } else {
            hsp = lerp(hsp, 0, 0.15);
        }

        if (_dir_y != 0) {
            vsp = lerp(vsp, _dir_y * _medusa_spd, 0.2);
        } else {
            vsp += grv * 0.5;
            vsp = clamp(vsp, -4, 4);
        }

        globos_medusa_step();
    }
    else if (is_transformed && transform_type == 11) {
        var _dir_x = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
        var _dir_y = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));
        var _hada_spd = 3.2;

        is_dashing = false;
        nube_fase_active = false;
        slam_timer = 0;

        if (tf_cooldown > 0) tf_cooldown--;

        if (_dir_x != 0) {
            hsp = lerp(hsp, _dir_x * _hada_spd, 0.2);
            image_xscale = sign(_dir_x) * esc_base;
        } else {
            hsp = lerp(hsp, 0, 0.15);
        }

        if (_dir_y != 0) {
            vsp = lerp(vsp, _dir_y * _hada_spd, 0.2);
        } else {
            var _flote_hada = sin(current_time * 0.004) * 0.6;
            vsp = lerp(vsp, _flote_hada, 0.1);
        }
    }
    else if (is_transformed && transform_type == 12) {
        var _dir_x = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
        var _dir_y = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));
        var _arpia_spd = 4.8;

        is_dashing = false;
        nube_fase_active = false;
        slam_timer = 0;

        if (tf_cooldown > 0) tf_cooldown--;

        if (arpia_picada > 0) {
            arpia_picada--;
            var _dir_picada = (image_xscale >= 0) ? 1 : -1;
            hsp = _dir_picada * 8;
            vsp = 7;
        } else {
            if (_dir_x != 0) {
                hsp = lerp(hsp, _dir_x * _arpia_spd, 0.2);
                image_xscale = sign(_dir_x) * esc_base;
            } else {
                hsp = lerp(hsp, 0, 0.15);
            }

            if (_dir_y != 0) {
                vsp = lerp(vsp, _dir_y * _arpia_spd, 0.2);
            } else {
                vsp = lerp(vsp, 0, 0.15);
            }
        }
    }
    // --- TRANSFORMACIÓN 13 (Imán / Ingeniera Magnética): se pega y avanza por partes ---
    else if (is_transformed && transform_type == 13) {
        var _x_hold = keyboard_check(ord("X"));
        var _dir_y = (keyboard_check(vk_down) || keyboard_check(ord("S"))) - (keyboard_check(vk_up) || keyboard_check(ord("W")));

        is_dashing = false;
        nube_fase_active = false;
        slam_timer = 0;

        if (iman_suelta_cd > 0) iman_suelta_cd--;

        if (!iman_pegado) {
            // Camina y salta, pero más pesada que Gaby normal
            var _iman_spd = iman_vel * vel_mult;
            if (_en_telarana) _iman_spd *= 0.4;

            if (move != 0) {
                hsp += move * _aceleracion;
                hsp = clamp(hsp, -_iman_spd, _iman_spd);
                image_xscale = sign(move) * abs(image_xscale);
            } else {
                hsp = lerp(hsp, 0, _friccion);
                if (abs(hsp) < 0.1) hsp = 0;
            }

            vsp += grv * iman_grv_mult * grav_mult;
            vsp = min(vsp, 10);

            if (coyote_timer > 0 && jump_buffer > 0) {
                vsp = iman_salto * salto_mult;
                if (_en_telarana) vsp *= 0.5;
                coyote_timer = 0;
                jump_buffer = 0;
            }

            iman_sx = lerp(iman_sx, 1, 0.2);
            iman_sy = lerp(iman_sy, 1, 0.2);

            // Mantener X: se pega a la superficie que esté tocando
            if (_x_hold && iman_suelta_cd <= 0) {
                var _sup = "";
                if (place_meeting(x - 1, y, obj_wall)) _sup = "izq";
                else if (place_meeting(x + 1, y, obj_wall)) _sup = "der";
                else if (place_meeting(x, y - 1, obj_wall)) _sup = "techo";
                else if (place_meeting(x, y + 1, obj_wall)) _sup = "suelo";

                if (_sup != "") {
                    iman_pegado = true;
                    iman_superficie = _sup;
                    hsp = 0;
                    vsp = 0;
                    iman_paso_timer = 0;
                    iman_paso_cd = 0;
                }
            }
        }
        else {
            // Hacia dónde está la superficie
            var _sx = 0;
            var _sy = 0;
            switch (iman_superficie) {
                case "izq":   _sx = -1; break;
                case "der":   _sx = 1;  break;
                case "techo": _sy = -1; break;
                default:      _sy = 1;  break;
            }
            var _horizontal = (_sy != 0); // en suelo/techo avanza a los lados, en paredes arriba/abajo
            hsp = 0;
            vsp = 0;

            if (iman_paso_timer > 0) {
                // Pasito en curso (arranca suave y frena suave)
                iman_paso_timer--;
                var _t = 1 - (iman_paso_timer / iman_paso_dur);
                var _e = (_t < 0.5) ? (2 * _t * _t) : (1 - power(-2 * _t + 2, 2) / 2);
                var _meta = iman_paso_desde + iman_paso_dir * iman_paso_dist * _e;
                if (_horizontal) hsp = _meta - x; else vsp = _meta - y;

                // Se estira al avanzar, como gusanito
                var _k = sin(_t * pi);
                iman_sx = 1 + _k * 0.3;
                iman_sy = 1 - _k * 0.2;

                if (iman_paso_timer <= 0) iman_paso_cd = iman_paso_pausa;
            }
            else {
                iman_sx = lerp(iman_sx, 1, 0.3);
                iman_sy = lerp(iman_sy, 1, 0.3);
                if (iman_paso_cd > 0) iman_paso_cd--;

                var _dir = _horizontal ? move : _dir_y;
                if (_dir != 0 && iman_paso_cd <= 0) {
                    iman_paso_timer = iman_paso_dur;
                    iman_paso_dir = sign(_dir);
                    iman_paso_desde = _horizontal ? x : y;
                    if (_horizontal) image_xscale = sign(_dir) * abs(image_xscale);
                }
            }

            // Si se acabó la superficie, se despega y cae
            if (iman_paso_timer <= 0 && !place_meeting(x + _sx * 2, y + _sy * 2, obj_wall)) {
                iman_pegado = false;
            }

            // Soltar X: se despega
            if (!_x_hold) {
                iman_pegado = false;
                hsp = -_sx * 2;
            }
            // Pegada al suelo: arriba/W la hace saltar despegándose
            else if (key_jump && iman_superficie == "suelo") {
                iman_pegado = false;
                iman_suelta_cd = 10;
                vsp = iman_salto * salto_mult;
            }
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

        vsp += grv * grav_mult;

        if (coyote_timer > 0 && jump_buffer > 0) {
            var _salto_base = is_transformed ? jump_spd_ball : jump_spd_standard;
            
            if (is_transformed && transform_type == 6) {
                _salto_base = (tobogan_inflado_timer > 0) ? -10 : -7;
            }
            
            if (_en_telarana) {
                vsp = _salto_base * 0.5 * salto_mult;
            } else {
                vsp = _salto_base * salto_mult;
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
    else if (is_transformed && transform_type == 10) {
        if (key_atk_z && !is_poisoned && !is_hit && medusa_zcd <= 0) {
            medusa_zcd = 50;
            var _p = globos_medusa_pos(GLOBO_Z);
            var _g = instance_create_layer(_p.x, _p.y, "Instances", obj_globo_explosivo);
            _g.hsp = ((image_xscale >= 0) ? 1 : -1) * 5;
            globos_medusa_soltar(GLOBO_Z);
            fx_pop_globo(_p.x, _p.y, 6);
        }

        if (key_atk_x && !is_poisoned && !is_hit && medusa_xcd <= 0) {
            medusa_xcd = 70;
            medusa_lock = 18;
            hsp *= 0.3;
            instance_create_layer(x, y - 40, "Instances", obj_onda_pulso);
            for (var i = 0; i < GLOBOS_N; i++) {
                gl_vel[i] += random_range(-14, 14);
                var _pg = globos_medusa_pos(i);
                var _s = instance_create_layer(_pg.x, _pg.y, "Instances", obj_efecto_chispa);
                _s.dir = random(360);
                _s.image_blend = make_color_rgb(159, 244, 255);
            }
            screen_shake(3);
        }
    }
    else if (is_transformed && transform_type == 6) {
        var _dir_t = (image_xscale >= 0) ? 1 : -1;
        if (tobogan_inflado_timer > 0) {
            tobogan_inflado_timer--;
            image_xscale = lerp(image_xscale, 1.3 * esc_base * _dir_t, 0.15);
            image_yscale = lerp(image_yscale, 1.4 * esc_base, 0.15);
        } else {
            tobogan_inflado_timer = 0;
            image_xscale = lerp(image_xscale, 1.0 * esc_base * _dir_t, 0.15);
            image_yscale = lerp(image_yscale, 1.0 * esc_base, 0.15);
        }

        if (key_atk_z && !is_poisoned && tobogan_inflado_timer <= 0) {
            tobogan_inflado_timer = 300; 
        }

        if (key_atk_x && !is_poisoned && !is_dashing) {
            var _dir_embestida = (image_xscale >= 0) ? 1 : -1;
            hsp = _dir_embestida * 10;
            is_dashing = true;
            tobogan_dash_timer = 15;
        }

        if (is_dashing) {
            tobogan_dash_timer--;
            var _enemy_hit = instance_place(x + hsp, y, obj_enemy_parent);
            if (_enemy_hit != noone) {
                with (_enemy_hit) {
                    hsp = sign(other.hsp) * 8;
                    vsp = -4;
                }
            }
            if (tobogan_dash_timer <= 0) {
                is_dashing = false;
            }
        }
    }
    else if (is_transformed && transform_type == 7) {
        var _dir_x = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
        var _dir_y = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));
        var _sucubo_spd = 4.0; 
        
        if (_dir_x != 0) {
            hsp = lerp(hsp, _dir_x * _sucubo_spd, 0.2);
            image_xscale = sign(_dir_x) * abs(image_xscale);
        } else {
            hsp = lerp(hsp, 0, 0.15);
        }
        
        if (_dir_y != 0) {
            vsp = lerp(vsp, _dir_y * _sucubo_spd, 0.2);
        } else {
            vsp = lerp(vsp, 0, 0.15); 
        }

        if (key_atk_z && !is_poisoned && !instance_exists(obj_bola_fuego_sucubo)) {
            var _dir_fuego = (image_xscale >= 0) ? 1 : -1;
            var _spawn_x = x + (_dir_fuego * 23);
            var _spawn_y = y - 40; 
            
            var _fuego = instance_create_layer(_spawn_x, _spawn_y, "front", obj_bola_fuego_sucubo);
            _fuego.hsp = _dir_fuego * 6;
            _fuego.image_xscale = image_xscale;
        }

        if (key_atk_x && !is_poisoned && !instance_exists(obj_beso_sucubo)) {
            var _dir_beso = (image_xscale >= 0) ? 1 : -1;
            var _spawn_x = x + (_dir_beso * 20);
            var _spawn_y = y - 40; 
            
            var _beso = instance_create_layer(_spawn_x, _spawn_y, "front", obj_beso_sucubo);
            _beso.hsp = _dir_beso * 4;
            _beso.image_xscale = image_xscale;
        }
    }
    else if (is_transformed && transform_type == 8) {
        var _dir_x = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
        var _dir_y = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));
        var _ninfa_spd = 4.0; 
        
        if (_dir_x != 0) {
            hsp = lerp(hsp, _dir_x * _ninfa_spd, 0.2);
            image_xscale = sign(_dir_x) * abs(image_xscale);
        } else {
            hsp = lerp(hsp, 0, 0.15);
        }
        
        if (_dir_y != 0) {
            vsp = lerp(vsp, _dir_y * _ninfa_spd, 0.2);
        } else {
            vsp = lerp(vsp, 0, 0.15); 
        }

        if (key_atk_z && !is_poisoned) {
        }

        if (key_atk_x && !is_poisoned) {
        }
    }     
    else if (is_transformed && transform_type == 11) {
        if (key_atk_x && !is_poisoned && tf_cooldown <= 0) {
            var _dir_polvo = (image_xscale >= 0) ? 1 : -1;
            var _polvo = instance_create_layer(x + (_dir_polvo * 20), y - 20, "Instances", obj_polvo_hada);
            _polvo.hsp = _dir_polvo * 6;
            tf_cooldown = 18;
        }
    }
    else if (is_transformed && transform_type == 12) {
        if (key_atk_z && !is_poisoned && tf_cooldown <= 0 && arpia_picada <= 0) {
            arpia_picada = 18;
            tf_cooldown = 50;
        }

        if (arpia_picada > 0) {
            var _enemy_picada = instance_place(x + hsp, y + vsp, obj_enemy_parent);
            if (_enemy_picada != noone) {
                with (_enemy_picada) {
                    instance_destroy();
                }
            }
        }
    }
    // --- TRANSFORMACIÓN 13 (Imán): Z = repeler ---
    else if (is_transformed && transform_type == 13) {
        if (iman_repel_cd > 0) iman_repel_cd--;

        if (key_atk_z && !is_poisoned && iman_repel_cd <= 0) {
            iman_repel_cd = iman_repel_cd_max;
            var _cx = x;
            var _cy = (bbox_top + bbox_bottom) / 2;
            iman_onda_timer = 20;
            iman_onda_x = _cx;
            iman_onda_y = _cy;
            screen_shake(2);

            // Empuja a los enemigos cercanos (los que se pueden aturdir) y los frena un momento
            with (all) {
                if (id != other.id && variable_instance_exists(id, "stun_timer")) {
                    var _ex = (bbox_left + bbox_right) / 2;
                    var _ey = (bbox_top + bbox_bottom) / 2;
                    if (point_distance(_cx, _cy, _ex, _ey) < other.iman_repel_radio) {
                        stun_timer = max(stun_timer, 40);
                        var _dir_e = sign(_ex - _cx);
                        if (_dir_e == 0) _dir_e = 1;
                        array_push(other.iman_empujados, { inst: id, vel: _dir_e * other.iman_repel_fuerza });
                    }
                }
            }

            // Si estaba pegada, se repele de la superficie y sale disparada (salto magnético)
            if (iman_pegado) {
                iman_pegado = false;
                iman_suelta_cd = 12;
                iman_paso_timer = 0;
                switch (iman_superficie) {
                    case "izq":   hsp = 10;  vsp = -5;  break;
                    case "der":   hsp = -10; vsp = -5;  break;
                    case "techo": hsp = 0;   vsp = 8;   break;
                    default:      hsp = 0;   vsp = -11 * salto_mult; break;
                }
            }
        }

        // Mueve a los enemigos empujados respetando las paredes (se van frenando)
        for (var i = array_length(iman_empujados) - 1; i >= 0; i--) {
            var _emp = iman_empujados[i];
            if (!instance_exists(_emp.inst) || abs(_emp.vel) < 0.5) {
                array_delete(iman_empujados, i, 1);
                continue;
            }
            with (_emp.inst) {
                if (!place_meeting(x + _emp.vel, y, obj_wall)) {
                    x += _emp.vel;
                } else {
                    _emp.vel = 0;
                }
            }
            _emp.vel *= 0.85;
        }
    }
    else {
        if (!is_transformed) {
            if (key_atk_z && !is_attacking && !is_poisoned) { current_weapon = 1; is_attacking = true; is_shooting = false; image_index = 0; }
            if (key_atk_x && !is_attacking && !is_poisoned) { current_weapon = 2; is_attacking = true; is_shooting = true; bullet_spawned = false; image_index = 0; }
        }
    }
} 

var _finalMoveX = hsp;
var _finalMoveY = vsp + viento_y;
viento_y = 0;

var _platform = noone;

if (!(is_transformed && (transform_type == 4 || transform_type == 5 || transform_type == 7 || transform_type == 9 || transform_type == 10 || transform_type == 11 || transform_type == 12)) && !(is_transformed && transform_type == 3 && is_dashing) && !(is_transformed && transform_type == 13 && iman_pegado)) {
    _platform = instance_place(x, y + max(1, _finalMoveY + 2), obj_plataforma_movil);
    if (!_platform) _platform = instance_place(x, y + max(1, _finalMoveY + 2), obj_plataforma_caida);
    if (!_platform) _platform = instance_place(x, y + max(1, _finalMoveY + 2), obj_plataforma_atravesable);
}

if (_platform && _finalMoveY >= 0 && bbox_bottom <= _platform.bbox_top + 4) {
    while (!place_meeting(x, y + sign(_finalMoveY), _platform)) {
        y += sign(_finalMoveY);
    }
    
    if (is_transformed && (transform_type == 1 || transform_type == 6) && _finalMoveY > 0) {
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
    
    if (is_transformed && (transform_type == 1 || transform_type == 6) && _finalMoveY > 0) {
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
            var _spawn_x = x + ((15 * image_xscale)) + (hsp * 2);
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
    if (is_transformed && (transform_type == 1 || transform_type == 6) && abs(hsp) > 0.1) {
        if (hsp > 0) image_xscale = abs(image_xscale);
        if (hsp < 0) image_xscale = -abs(image_xscale);
    }
    if (is_transformed && (transform_type == 3 || transform_type == 4 || transform_type == 5 || transform_type == 7 || transform_type == 9 || transform_type == 10 || transform_type == 11 || transform_type == 12) && abs(hsp) > 0.1) {
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
            } else if (transform_type == 6) {
                sprite_index = spr_gaby_tobogan; 
            } else if (transform_type == 7) {
                sprite_index = spr_gaby_socubus; 
            } else if (transform_type == 8) {
                sprite_index = spr_gaby_ninfa_TF;
            } else if (transform_type == 9) {
                if (abs(hsp) < 0.1 && abs(vsp) < 0.1) {
                    sprite_index = spr_gaby_avion_idle;
                    if (image_index >= image_number - 1) {
                        image_index = image_number - 1;
                        image_speed = 0;
                    } else {
                        image_speed = 1;
                    }
                } else {
                    sprite_index = spr_gaby_avion;
                    image_speed = 1;
                }
            } else if (transform_type == 10) {
                sprite_index = spr_ramo_base2; 
            }
            else if (transform_type == 11) {
                sprite_index = spr_gaby_hada;
            }
            else if (transform_type == 12) {
                sprite_index = spr_gaby_arpia;
            }
            else if (transform_type == 13) {
                sprite_index = spr_gaby_iman;
            }
        } else {
            if (current_weapon == 1) {
                sprite_index = (_is_grounded) ? (hsp != 0 ? sprGaby_walk : sprGaby_idle) : (vsp < 0 ? spr_jump_up : spr_jump_fall);
            } else {
                sprite_index = (_is_grounded) ? (hsp != 0 ? sprGaby_walk_shot : sprGaby_idle_shot) : (vsp < 0 ? spr_jump_up_shot : spr_jump_fall_shot);
            }
        }
    }
} 
else {
    hsp = lerp(hsp, 0, 0.2);
    vsp += grv;
    
    if (is_transformed) {
        if (transform_type == 1) {
            sprite_index = sprBalon_hit; 
        } 
        else if (transform_type == 2) {
            sprite_index = sprGabyCristal_hit; 
        } 
        else if (transform_type == 3) {
            sprite_index = spr_gaby_globo_hit; 
        } 
        else if (transform_type == 4) {
            sprite_index = spr_gaby_nube_hit; 
        } 
        else if (transform_type == 5) {
            sprite_index = spr_gaby_abeja_hit; 
        } 
        else if (transform_type == 6) {
            sprite_index = spr_gaby_tobogan_hit; 
        } 
        else if (transform_type == 7) {
            sprite_index = spr_gaby_socubus_hit; 
        } 
        else if (transform_type == 8) {
            if (variable_instance_exists(id, "golpe_ninfa_especial") && golpe_ninfa_especial) {
                sprite_index = spr_gaby_condon_arrugado; 
            } else {
                sprite_index = spr_gaby_condon_hit; 
            }
        }
        else if (transform_type == 9) {
            if (variable_instance_exists(id, "golpe_bruja_especial") && golpe_bruja_especial) {
                sprite_index = spr_gaby_avion_hit2; 
            } else {
                sprite_index = spr_gaby_avion_hit; 
            }
        }
        else if (transform_type == 10) {
            if (variable_instance_exists(id, "golpe_medusa_especial") && golpe_medusa_especial) {
                sprite_index = spr_gaby_medusa_hit2;
            } else {
                sprite_index = spr_gaby_medusa_hit; 
            }
        }
        else if (transform_type == 11) {
            if (variable_instance_exists(id, "golpe_hada_especial") && golpe_hada_especial) {
                sprite_index = spr_gaby_hada_hit2;
            } else {
                sprite_index = spr_gaby_hada_hit;
            }
        }
        else if (transform_type == 12) {
            if (variable_instance_exists(id, "golpe_arpia_especial") && golpe_arpia_especial) {
                sprite_index = spr_gaby_arpia_hit2;
            } else {
                sprite_index = spr_gaby_arpia_hit;
            }
        }
        else if (transform_type == 13) {
            iman_pegado = false;
            // Golpe especial de la Ingeniera: se vuelve imán metálico
            if (golpe_iman_especial) {
                sprite_index = spr_gaby_iman_hit2;
            } else {
                sprite_index = spr_gaby_iman; // (no hay sprite de hit normal todavía: parpadea en rojo en el Draw)
            }
        }
    } 
    else {
        image_blend = c_white;
        if (current_weapon == 1) {
            sprite_index = spr_Gaby_hit;          
        } else if (current_weapon == 2) {
            sprite_index = spr_Gaby_hit_shot;
        } else {
            sprite_index = spr_Gaby_hit;
        }
    }
    
    if (image_index >= image_number - 1) { 
        is_hit = false; 
        image_blend = c_white;
        if (variable_instance_exists(id, "golpe_ninfa_especial")) {
            golpe_ninfa_especial = false;
        }
        
        if (variable_instance_exists(id, "golpe_bruja_especial")) {
            golpe_bruja_especial = false;
        }

        if (variable_instance_exists(id, "golpe_medusa_especial")) {
            golpe_medusa_especial = false;
        }

        if (variable_instance_exists(id, "golpe_hada_especial")) {
            golpe_hada_especial = false;
        }

        if (variable_instance_exists(id, "golpe_arpia_especial")) {
            golpe_arpia_especial = false;
        }

        golpe_iman_especial = false;
    }
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

if (is_transformed && (transform_type == 1 || transform_type == 6)) {
    var _dir_b = (image_xscale >= 0) ? 1 : -1;
    if (!_is_grounded) {
        if (vsp > 2) {
            image_yscale = lerp(image_yscale, 1.3 * esc_base, 0.2);
            image_xscale = lerp(image_xscale, 0.8 * esc_base * _dir_b, 0.2);
        } else if (vsp < -2) {
            image_yscale = lerp(image_yscale, 1.2 * esc_base, 0.2);
            image_xscale = lerp(image_xscale, 0.9 * esc_base * _dir_b, 0.2);
        } else {
            image_yscale = lerp(image_yscale, 1 * esc_base, 0.2);
            image_xscale = lerp(image_xscale, 1 * esc_base * _dir_b, 0.2);
        }
    } else {
        if (abs(hsp) > 1) {
            image_yscale = lerp(image_yscale, 0.8 * esc_base, 0.2);
            image_xscale = lerp(image_xscale, 1.2 * esc_base * sign(hsp), 0.2);
        } else {
            image_yscale = lerp(image_yscale, 1 * esc_base, 0.2);
            image_xscale = lerp(image_xscale, 1 * esc_base * _dir_b, 0.2);
        }
    }
}

grav_mult = 1;
salto_mult = 1;
vel_mult = 1;
