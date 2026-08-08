startX = x;

_distancia = 160; 

_dir = image_xscale; 
if (_dir == 0) _dir = 1;

targetX = startX + (_distancia * _dir);

estado = "ESPERANDO"; 
cronometro = 0;
tiempo_espera = 60;