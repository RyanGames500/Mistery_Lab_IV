completar_nivel_actual();

// Variable para controlar qué pantalla mostrar (0 = Victoria normal, 1 = ¡Mundo completado!)
fase_victoria = 0; 

// Verificamos si este nivel era el último (nivel 9, que es el décimo nivel)
es_ultimo_nivel_del_mundo = (global.nivel_activo == array_length(global.mundos[global.mundo_activo].niveles) - 1);