with (other) {
    if (current_time >= hit_next) {
        hit_next = current_time + 350;   // 350 ms de protección entre golpes
        hp -= 10;
        screen_shake(1);

        if (hp <= 0) {
            instance_destroy();
        } else {
            stun_timer = 12;             // se frena un momento al recibir el golpe
        }
    }
}