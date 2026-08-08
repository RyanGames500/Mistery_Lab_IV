var _dist = point_distance(x, y, obj_jugador.x, obj_jugador.y);

// Verificamos si están cerca y si el camino está libre de paredes sólidas intermedias
if (_dist < rango_atraccion && _dist > 15) {
    
    // Usamos collision_line pero revisando contra el centro del jugador
    var _hay_pared = collision_line(x, y, obj_jugador.x, obj_jugador.y, obj_wall, true, true);
    
    // Si no hay pared de por medio, o si la distancia vertical es pequeña (mismo nivel), jalamos con todo
    if (!_hay_pared || abs(y - obj_jugador.y) < 24) {
        var _dir = point_direction(obj_jugador.x, obj_jugador.y, x, y);
        var _pull_x = lengthdir_x(fuerza_pull, _dir);
        var _pull_y = lengthdir_y(fuerza_pull, _dir);
        
        with (obj_jugador) {
            if (!place_meeting(x + _pull_x, y, obj_wall)) {
                x += _pull_x;
            }
            if (!place_meeting(x, y + _pull_y, obj_wall)) {
                y += _pull_y;
            }
        }
    }
}

// Instakill con animación de succión por código
if (place_meeting(x, y, obj_jugador)) {
    with (obj_jugador) {
        player_take_damage(999, true, 0); 
        death_type = "hoyo_negro"; 
        
        x = other.x;
        y = other.y;
        
        hsp = 0;
        vsp = 0;
    }
}

var _ang = random(360);
var _radio = random_range(50, rango_atraccion);
var _spawn_x = x + lengthdir_x(_radio, _ang);
var _spawn_y = y + lengthdir_y(_radio, _ang);

var _angulo_hacia_centro = point_direction(_spawn_x, _spawn_y, x, y);
part_type_direction(part_tipo, _angulo_hacia_centro, _angulo_hacia_centro, 0, 0);

part_emitter_region(part_sys, part_emit, _spawn_x - 5, _spawn_x + 5, _spawn_y - 5, _spawn_y + 5, ps_shape_ellipse, ps_distr_linear);
part_emitter_burst(part_sys, part_emit, part_tipo, 1);