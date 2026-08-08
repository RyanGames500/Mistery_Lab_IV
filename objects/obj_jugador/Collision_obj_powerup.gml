// Al colisionar con el ítem de transformación:
if (!is_transforming && !is_transformed) {
    is_transforming = true;
    hsp = 0;
    image_index = 0;
    sprite_index = spr_gaby_transformando; // Pon el nombre exacto de tu sprite de transformación
    instance_destroy(other); // Destruye el ítem
}