// Tamaño = el sprite estirado en el room
ancho = sprite_width;
alto = sprite_height;

// Configuración (se puede cambiar por instancia en el Creation Code)
direccion = 90;          // 90 arriba, 270 abajo, 0 derecha, 180 izquierda
fuerza = 2.5;            // intensidad del empuje

// Modo intermitente
intermitente = false;    // true = se enciende y apaga solo
t_on = 180;              // frames encendida
t_off = 120;             // frames apagada
t_aviso = 40;            // frames de aviso antes de encenderse
ciclo = 0;

// Estado
activa = true;
avisando = false;
aviso_inv = 0;

// La Soberana la llama para invertir la dirección (con aviso)
invertir = function() {
    if (aviso_inv > 0) return;
    aviso_inv = 40;
};