with (other) {
    if (variable_global_exists("hp")) {
        global.hp = min(global.hp + 1, 63); 
    } else {
        hp = min(hp + 1, 6);
    }
}
instance_destroy();