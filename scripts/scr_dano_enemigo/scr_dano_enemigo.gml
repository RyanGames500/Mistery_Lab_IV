function enemigo_recibir_dano(_e, _dano, _stun) {
    with (_e) {
        if (variable_instance_exists(id, "hp")) {
            if (!variable_instance_exists(id, "hit_next")) hit_next = 0;
            if (current_time >= hit_next) {
                hit_next = current_time + 350;
                hp -= _dano;
                screen_shake(1);
                if (hp <= 0) instance_destroy();
                else stun_timer = _stun;
            }
        } else {
            instance_destroy();
        }
    }
}