if (is_knocked) {
    knockback_timer--;
    if (knockback_timer <= 0) {
        is_knocked = false;
        hsp = 0;
    }
}

if(hp<=0){instance_destroy();}

// Aplicar gravedad y movimiento
x += hsp;
y += vsp;