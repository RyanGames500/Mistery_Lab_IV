
if os_type=os_android or os_type=os_windows{
global.inicx=display_get_width()
global.inicy=display_get_height()
}else{
global.inicx=1280//display_get_width()
global.inicy=720//display_get_height()	
	
}
global.razx=1;
aspect_ratio=global.inicx/global.inicy
window_set_size(global.inicx,global.inicy)
if aspect_ratio<(1/0.65){aspect_ratio=1/0.65}
if aspect_ratio>(1/0.45){aspect_ratio=1/0.45}
global.razx=(720*aspect_ratio)/1280; 

surface_resize(application_surface,720*aspect_ratio,720)
camera_set_view_size(view_camera[0],225*aspect_ratio,225)
device_mouse_dbclick_enable(false)
act=0;

global.galeria_items = [
    { item_id: 0, sprite: sprBalon_idle, unlocked: false,  name: "Transformacion Bola" },
    { item_id: 1, sprite: spr_test_1, unlocked: false, name: "Transformacion Cristal" },
];

global.hp = 6;    
global.max_hp = 6;
global.ammo = 10; 
global.max_ammo = 10;


cargar_galeria();