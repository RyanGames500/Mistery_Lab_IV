enum ESTADO_TRITURADORA { ESPERA, PREPARACION, CAIDA, GOLPE, RECUPERACION }

estado = ESTADO_TRITURADORA.ESPERA;
timer = 60;
temblor = 0;
vel_caida = 0;
onda_timer = 0;

// Posiciones (el destino se busca solo: el primer suelo debajo de ella)
y_original = y;
y_destino = y;
while (!place_meeting(x, y_destino + 1, obj_wall) && y_destino < room_height + 64) y_destino++;
alto_pie = bbox_bottom - y;      // distancia del origen a la base de la máscara

// Ritmo (a 60 fps) - mantenlo constante para que se pueda sincronizar
rango_activacion = 360;          // solo trabaja si Gaby está así de cerca
rango_onda = 160;                // alcance horizontal de la onda de choque
tiempo_espera = 100;
tiempo_aviso = 40;
tiempo_golpe = 35;
ventana_onda = 10;               // frames en que la onda puede dañar
vel_subida = 2;
fuerza_impacto = 5;

// Vida y efectos
hp = 60;
hit_next = 0;
stun_timer = 0;

// Daño estándar a Gaby
hacer_dano = function() {
    if (!instance_exists(obj_jugador)) return;
    var _ex = x;
    with (obj_jugador) {
        if (!is_dead && !is_transforming && !invincible) {
            player_take_damage(1, false, 1);
            if (global.hp <= 0) {
                is_dead = true;
            }
            invincible = true;
            alarm[2] = 90;

            var _dir_empuje = sign(x - _ex);
            if (_dir_empuje == 0) _dir_empuje = 1;
            hsp = _dir_empuje * 4;
            vsp = -3;
        }
    }
};