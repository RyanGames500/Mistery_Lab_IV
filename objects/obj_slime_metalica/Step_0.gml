var oPlayer = obj_jugador;

// --- CONTROL DEL EFECTO DE STUN / MIEL ---
if (variable_instance_exists(id, "stun_timer") && stun_timer > 0) {
    stun_timer--;
    hsp = 0;
    vsp = 0;
    exit; 
}

if (variable_instance_exists(id, "miel_timer") && miel_timer > 0) {
    miel_timer--;
    hsp *= 0.5; // Si cae en miel, se mueve y rebota mucho más lento
}

// Aplicar gravedad constante
vsp += grav;

// --- COLISIONES HORIZONTALES ---
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) {
        x += sign(hsp);
    }
    hsp *= -1; // Invierte la dirección horizontal si choca con una pared lateral
}
x += hsp;

// Actualizar orientación del sprite según hacia dónde salta
if (hsp != 0) {
    image_xscale = sign(hsp);
}

// --- COLISIONES VERTICALES Y REBOTE AUTOMÁTICO ---
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    
    // Si toca el suelo, rebota inmediatamente hacia arriba de forma automática
    vsp = vel_salto_rebote;
    
    // Opcional: un pequeño efecto de screen_shake muy ligero al rebotar contra el suelo
    // if (abs(vsp) > 4) { screen_shake(2); }
}
y += vsp;

// --- DAÑO A GABY (Uso del estándar seguro) ---
if (place_meeting(x, y, oPlayer)) {
    with (oPlayer) {
        if (!is_dead && !is_transforming && !invincible) {
            
            player_take_damage(1, false, 1); 
            if (global.hp <= 0) {
                is_dead = true;
            }
            
            invincible = true;
            alarm[2] = 90; // Invulnerabilidad temporal
            
            // Empuje al tocar el slime
            var _dir_empuje = sign(x - other.x);
            if (_dir_empuje == 0) _dir_empuje = 1;
            hsp = _dir_empuje * 4;
            vsp = -3;
        }
    }
}