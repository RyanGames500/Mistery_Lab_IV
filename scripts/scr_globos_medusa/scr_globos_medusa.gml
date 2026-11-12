#macro GLOBOS_N 11
#macro GLOBO_Z 2

function globos_ease_back(_p) {
    var _c1 = 1.70158;
    var _c3 = _c1 + 1;
    return 1 + _c3 * power(_p - 1, 3) + _c1 * power(_p - 1, 2);
}

function globos_medusa_init() {
    gl_px = [3, -6.5, 8, -0.5, -17.5, 18.5, 1, 2, -1.5, 2, 3];
    gl_py = [-26, -43, -51, -52, -38, -42, -37, -32, -18, -17, -15];

    gl_len = []; gl_d0 = [];
    gl_ang = []; gl_vel = [];
    gl_ox = []; gl_oxv = [];
    gl_oy = []; gl_oyv = [];
    gl_rig = []; gl_amo = []; gl_fas = []; gl_ine = [];
    gl_vivo = []; gl_crece = [];

    for (var i = 0; i < GLOBOS_N; i++) {
        var _vx = -gl_px[i];
        var _vy = -gl_py[i];
        gl_len[i] = point_distance(0, 0, _vx, _vy);
        gl_d0[i]  = point_direction(0, 0, _vx, _vy);

        gl_ang[i] = 0;
        gl_vel[i] = random_range(-4, 4);
        gl_ox[i] = 0;  gl_oxv[i] = 0;
        gl_oy[i] = 0;  gl_oyv[i] = 0;

        gl_rig[i] = 0.04 + random(0.04);
        gl_amo[i] = 0.08 + random(0.04);
        gl_fas[i] = random(6.28);
        gl_ine[i] = 0.8 + random(0.5);

        gl_vivo[i] = true;
        gl_crece[i] = 1;
    }

    gl_en_hit = false;
    gl_infla = 1;
    gl_listo = true;
}

function globos_medusa_step() {
    if (!variable_instance_exists(id, "gl_listo")) globos_medusa_init();

    if (gl_en_hit) {
        gl_en_hit = false;
        gl_infla = 0;
        for (var i = 0; i < GLOBOS_N; i++) {
            gl_vel[i]  += random_range(-12, 12);
            gl_oxv[i]  += random_range(-3, 3);
            gl_oyv[i]  += random_range(-4, 1);
        }
    }
    if (gl_infla < 1) gl_infla = min(1, gl_infla + 1 / 24);

    var _t = current_time * 0.001;
    for (var i = 0; i < GLOBOS_N; i++) {
        if (gl_crece[i] < 1) gl_crece[i] = min(1, gl_crece[i] + 1 / 50);

        var _tgt = clamp(hsp * 2.6 * gl_ine[i] + sin(_t * (1.1 + i * 0.13) + gl_fas[i]) * 4, -35, 35);
        gl_vel[i] += (_tgt - gl_ang[i]) * gl_rig[i];
        gl_vel[i] *= (1 - gl_amo[i]);
        gl_ang[i] += gl_vel[i];

        var _tx = -hsp * 1.5 * gl_ine[i];
        gl_oxv[i] += (_tx - gl_ox[i]) * 0.10;
        gl_oxv[i] *= 0.82;
        gl_ox[i]  += gl_oxv[i];

        var _ty = -vsp * 1.2 * gl_ine[i] + sin(_t * 1.7 + gl_fas[i]) * 2.2;
        gl_oyv[i] += (_ty - gl_oy[i]) * 0.10;
        gl_oyv[i] *= 0.82;
        gl_oy[i]  += gl_oyv[i];
    }
}

function globos_medusa_pos(_i) {
    var _esc = abs(image_xscale);
    var _d = gl_d0[_i] + gl_ang[_i];
    return {
        x: x + (gl_px[_i] + lengthdir_x(gl_len[_i], _d) + gl_ox[_i]) * _esc,
        y: y + (gl_py[_i] + lengthdir_y(gl_len[_i], _d) + gl_oy[_i]) * _esc
    };
}

function globos_medusa_soltar(_i) {
    gl_crece[_i] = 0;
    gl_vel[_i] += random_range(-14, 14);
    for (var k = 0; k < GLOBOS_N; k++) gl_vel[k] += random_range(-3, 3);
}

function globos_medusa_reventar() {
    var _k = -1;
    var _mejor = -99999;
    for (var i = 0; i < GLOBOS_N; i++) {
        if (gl_vivo[i] && gl_py[i] > _mejor) { _mejor = gl_py[i]; _k = i; }
    }
    if (_k == -1) return false;

    var _p = globos_medusa_pos(_k);
    gl_vivo[_k] = false;
    fx_pop_globo(_p.x, _p.y, 10);
    screen_shake(2);
    return true;
}

function fx_pop_globo(_x, _y, _n) {
    repeat (_n) {
        var _c = instance_create_layer(_x, _y, "Instances", obj_efecto_chispa);
        _c.dir = random(360);
        _c.velocidad_chispa = random_range(2, 4);
        _c.vida_util = irandom_range(18, 34);
        _c.image_blend = choose(c_white, make_color_rgb(255, 170, 120), make_color_rgb(255, 215, 70), make_color_rgb(40, 70, 160));
    }
}

function globos_medusa_dibujar() {
    if (!variable_instance_exists(id, "gl_listo")) globos_medusa_init();

    if (is_hit && !is_dead) {
        gl_en_hit = true;
        var _especial = variable_instance_exists(id, "golpe_medusa_especial") && golpe_medusa_especial;
        var _spr = _especial ? spr_gaby_medusa_hit2 : spr_gaby_medusa_hit;
        var _dir = (image_xscale >= 0) ? 1 : -1;
        var _off = 0;
        if (_especial) _off = (image_index < 4) ? 27 : 20;
        draw_sprite_ext(_spr, image_index, x - _off * _dir * abs(image_xscale), y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
        return;
    }

    var _esc = abs(image_xscale);
    var _m = 0.55 + 0.45 * globos_ease_back(gl_infla);

    var _hay = false;
    for (var i = 0; i < GLOBOS_N; i++) if (gl_vivo[i]) _hay = true;
    if (_hay) draw_sprite_ext(spr_ramo_base2, 0, x, y, _esc, image_yscale, 0, image_blend, image_alpha);

    for (var i = 0; i < GLOBOS_N; i++) {
        if (!gl_vivo[i]) continue;
        var _gm = (gl_crece[i] < 1) ? globos_ease_back(gl_crece[i]) : 1;
        if (_gm < 0.02) continue;

        var _d = gl_d0[i] + gl_ang[i];
        var _px = x + (gl_px[i] + lengthdir_x(gl_len[i], _d) + gl_ox[i]) * _esc;
        var _py = y + (gl_py[i] + lengthdir_y(gl_len[i], _d) + gl_oy[i]) * _esc;

        var _gel = current_time * 0.006 + i * 0.6;
        var _sx = _esc * _m * _gm * (1 + sin(_gel) * 0.03);
        var _sy = image_yscale * _m * _gm * (1 + cos(_gel) * 0.03);

        draw_sprite_ext(spr_ramo_partes, i, _px, _py, _sx, _sy, gl_ang[i], image_blend, image_alpha);
    }
}