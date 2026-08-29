x += lengthdir_x(velocidad_chispa, dir);
y += lengthdir_y(velocidad_chispa, dir);

vida_util--;
if (vida_util <= 0) {
    instance_destroy();
}