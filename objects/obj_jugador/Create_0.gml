#region CONFIG
hsp = 0; 
vsp = 0; 
grv = 0.3;
hp = 5;
hp_max = 5;
is_dead = false;
is_hit = false;
invincible = false; 
walk_spd = 3;
run_spd = 6;
jump_spd = -7;
current_spd = walk_spd;
is_attacking = false;
is_shooting = false;
sprite_idle = sprGaby_idle;
sprite_run = sprGaby_walk;
sprite_jump = spr_jump_up;
sprite_atk = sprGaby_shot;
sprite_atk_jump = sprGaby_jump_shot;
sprite_melee_ground = sprGaby_melee;
sprite_melee_air = sprGaby_jump_melee;
key_left = 0;
key_right = 0;
key_jump = 0;
key_run = 0;
key_atk_z = 0;
key_atk_x = 0;
key_space = 0;
melee_spawned = false;
is_hurt = false;
is_caught = false;
is_poisoned = false;
poison_timer = 0;
controls_inverted = false;
invert_timer = 0;
is_dashing = false;
slam_active = false;
slam_timer = 0;
flash_timer = 0;
arma_soltada = false;
landed = false;
can_move = true;
#endregion

#region Mejorar el Gameplay
coyote_timer = 0;
coyote_max = 6;
jump_buffer = 0;
buffer_max = 8;
#endregion


#region Muertes, Transformaciones, posiones CONFIG
death_type = 0;
current_weapon = 1; 
death_stage = 0; 
fade_alpha = 0; 
jump_spd_standard = -8; 
jump_spd_ball = -10;
bounce_factor = 0.6;
is_transformed = false;
is_transforming = false;
transform_type = 0; // 0 = Normal, 1 = Pelota, 2 = Cristal
form_normal = {
    spd: 3, jump: -8, grv: 0.3, 
    anim_idle: sprGaby_idle, anim_run: sprGaby_walk, anim_jump: spr_jump_up, anim_fall: spr_jump_fall
};
form_pelota = {
    spd: 2.5, jump: -8, grv: 0.2, 
    anim_idle: sprBalon_idle, anim_run: sprBalon_run, anim_jump: sprBalon_idle, anim_fall: sprBalon_idle
};
form_cristal = {
    spd: 4, jump: -6, grv: 0.1, 
    anim_idle: sprGabyCristal_idle, anim_run: sprGabyCristal_run, anim_jump: sprGabyCristal_jump, anim_fall: sprGabyCristal_jump
};
current_form = form_normal;

//solo para la transformacion de la pelota
is_dashing = false;
dash_spd = 12;
dash_timer = 0;
dash_cooldown = 30;
#endregion
// Estado Inicial
estado = "idle";