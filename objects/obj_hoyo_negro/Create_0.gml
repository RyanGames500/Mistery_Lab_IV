rango_atraccion = 150;
fuerza_pull = 2;

// Sistema de particulas para la succiin
part_sys = part_system_create();
part_system_depth(part_sys, -100); 

part_tipo = part_type_create();
part_type_shape(part_tipo, pt_shape_disk);
part_type_size(part_tipo, 0.05, 0.15, -0.001, 0); 
part_type_color1(part_tipo, c_purple);     
part_type_alpha2(part_tipo, 0.8, 0.2);
part_type_speed(part_tipo, 4, 6, -0.1, 0);        
part_type_life(part_tipo, 30, 50);             

// Emisor de particulas
part_emit = part_emitter_create(part_sys);