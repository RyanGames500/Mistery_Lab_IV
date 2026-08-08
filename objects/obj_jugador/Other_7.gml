if (is_attacking) {
    is_attacking = false;
    is_shooting = false;
    bullet_spawned = false;
    melee_spawned = false;
}


if (is_transforming) {
    is_transforming = false;
    is_transformed = true;
    transform_type = 1; // 1 = Balón
}