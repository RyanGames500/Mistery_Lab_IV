if (!activo) exit;


if (keyboard_check_pressed(vk_escape)) {
    activo = false;
    instance_activate_all();
}

var _vmove = keyboard_check_pressed(vk_up) - keyboard_check_pressed(vk_down);
target_scroll += _vmove * 100;
target_scroll = clamp(target_scroll + (_vmove * 100), -80, 0);
scroll_y = lerp(scroll_y, target_scroll, 0.1);