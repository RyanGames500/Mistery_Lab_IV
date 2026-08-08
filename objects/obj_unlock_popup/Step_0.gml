
y_pos = lerp(y_pos, target_y, 0.1);
alpha = lerp(alpha, 1, 0.1);

if (alarm[0] < 60) alpha = lerp(alpha, 0, 0.1);