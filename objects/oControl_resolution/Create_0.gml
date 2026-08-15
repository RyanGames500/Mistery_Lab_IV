show_debug_message("Ruta de búsqueda: " + working_directory);

// Elegimos qué idioma cargar
global.pausado=false;
global.idioma_actual = "en"; 
cargar_idioma("lang_" + global.idioma_actual + ".json");


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
    { item_id: 0, sprite: sprBalon_galery, unlocked: false,  name: "Transformacion Bola" },
    { item_id: 1, sprite: spr_test_1, unlocked: false, name: "Transformacion Cristal" },
    { item_id: 2, sprite: spr_test_1, unlocked: false, name: "Transformacion Cristal" },
    { item_id: 3, sprite: spr_test_1, unlocked: false, name: "Transformacion Cristal" },
    { item_id: 4, sprite: spr_test_1, unlocked: false, name: "Transformacion Cristal" },
    { item_id: 5, sprite: spr_test_1, unlocked: false, name: "Transformacion Cristal" },
    { item_id: 6, sprite: spr_test_1, unlocked: false, name: "Transformacion Cristal" },
    { item_id: 7, sprite: spr_test_1, unlocked: false, name: "Transformacion Cristal" },
];

global.mundos = [
    {
        mundo_id: 1,
        nombre: tr("msg_etapa_1"),
        unlocked: true,
        niveles: [
            { nivel_id: 1, room_name: rm_plantilla, unlocked: true },
            { nivel_id: 2, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 3, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 4, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 5, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 6, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 7, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 8, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 9, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 10, room_name: rm_plantilla, unlocked: false }
        ]
    },
    {
        mundo_id: 2,
        nombre: tr("msg_etapa_2"),
        unlocked: false,
        niveles: [
            { nivel_id: 1, room_name: rm_test, unlocked: false }, // El primer nivel del mundo 2 puede empezar bloqueado hasta pasar el mundo 1
            { nivel_id: 2, room_name: rm_test, unlocked: false },
            { nivel_id: 3, room_name: rm_test, unlocked: false },
            { nivel_id: 4, room_name: rm_test, unlocked: false },
            { nivel_id: 5, room_name: rm_test, unlocked: false },
            { nivel_id: 6, room_name: rm_test, unlocked: false },
            { nivel_id: 7, room_name: rm_test, unlocked: false },
            { nivel_id: 8, room_name: rm_test, unlocked: false },
            { nivel_id: 9, room_name: rm_test, unlocked: false },
            { nivel_id: 10, room_name: rm_test, unlocked: false }
        ]
    },
    {
        mundo_id: 3,
        nombre: tr("msg_etapa_3"),
        unlocked: false,
        niveles: [
            { nivel_id: 1, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 2, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 3, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 4, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 5, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 6, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 7, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 8, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 9, room_name: rm_plantilla, unlocked: false },
            { nivel_id: 10, room_name: rm_plantilla, unlocked: false }
        ]
    }
];

global.mundo_activo = 0;
//tienda
global.coins = 100; 
global.item_ball_skin = false;
global.item_extra_ammo = false;
//HUD
global.hp = 6;    
global.max_hp = 6;
global.ammo = 10; 
global.max_ammo = 10;


//cargar el progreso guardado
cargar_galeria();
cargar_progreso_niveles();