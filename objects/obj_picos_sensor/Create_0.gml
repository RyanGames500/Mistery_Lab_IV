startY = y;           // Posición oculta (bajo el piso)
targetY = y - 32;     // Posición visible (fuera del piso - ajusta 32 según el tamaño de tu sprite)

cronometro = 0;
tiempo_oculto = 90;   // Cuánto tiempo se quedan abajo escondidos (frames)
tiempo_visible = 90;  // Cuánto tiempo se quedan arriba haciendo daño (frames)
estado = "OCULTO";    // Estados: "OCULTO", "SUBIENDO", "VISIBLE", "BAJANDO"