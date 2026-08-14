var circle_tam=135; //radio

draw_set_color(c_gray)
draw_set_alpha(0.4)
x = 180*global.razx;


image_xscale=1
image_yscale=1
if effect_alp>0{effect_alp-=0.1};

//draw_circle(x,y,circle_tam,0)
draw_sprite_ext(vPad_Base,0,x,y,5.5,5.5,0,c_white,0.5)

var mx = device_mouse_x(0) //window_mouse_get_x();
var my = device_mouse_y(0)//window_mouse_get_y();
var chh=0;
var press=0;
var sompress=0;
for(var i=0; i<2; i++) {
	chh=0;
	press=0;
	
	if device_mouse_x_to_gui(i)<(x+circle_tam+100){
	var mx =device_mouse_x_to_gui(i);
	var my = device_mouse_y_to_gui(i);
	chh=device_mouse_check_button(i,mb_left) //device_mouse_check_button(i,mb_left);
	press=device_mouse_check_button_pressed(i,mb_left);


if chh && sompress=0{
global.pointmo=point_direction(x,y,mx,my);
sompress=1;
if point_in_circle(mx,my,x,y,circle_tam){
act_x=mx;
act_y=my;
if not(global.pressjoy){
global.pressjoy=1;
effect_alp=1;
}

}else{
if (global.pressjoy){
act_x=x+lengthdir_x(circle_tam,global.pointmo);
act_y=y+lengthdir_y(circle_tam,global.pointmo);
}}

}

	}
}


if not(sompress){
act_x+=(x-act_x)/10;
act_y+=(y-act_y)/10;	
global.pressjoy=0;
}


draw_sprite_ext(sprite_index,image_index,act_x,act_y,2,2,0,c_white,1);

draw_sprite_ext(sprite_index,image_index,act_x,act_y,2,2,0,c_red,effect_alp);

draw_set_alpha(1)
draw_set_color(c_white)
