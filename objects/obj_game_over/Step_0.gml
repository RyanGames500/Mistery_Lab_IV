
alpha = min(alpha + 0.02, 1); 


if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down)) {
    selected = !selected;
}


if (keyboard_check_pressed(vk_enter)) {
    if (selected == 0) game_restart(); 
    else game_end();                  
}