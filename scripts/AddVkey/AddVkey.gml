function AddVkey(argument0) {
	var platform = os_type;
	if(platform == os_macosx || platform == os_macosx){
		instance_destroy();
	}else{
		virtual_key_add(x,y,sprite_get_width(sprite_index)* image_xscale, sprite_get_height(sprite_index)* image_yscale, argument0);
	}


}
