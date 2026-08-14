function scrInputs() {
    //WINDOWS / MAC / LINUX
    key_left = keyboard_check(ord("A")) || keyboard_check(vk_left);
    key_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
    key_jump = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
    key_run = keyboard_check(vk_shift);
    key_atk_z = keyboard_check_pressed(ord("Z"));
    key_atk_x = keyboard_check_pressed(ord("X"));
    key_space = keyboard_check_pressed(vk_space);
    if (key_space && is_transformed) { is_transformed = false; transform_type = 0; }
    
    //ANDROID / IPAD / TABLET
    if global.pressjoy{
	scrJoysctickInput(global.pointmo)
	}
}
