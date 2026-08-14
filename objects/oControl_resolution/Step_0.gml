if (act=0){
//act=1

global.inicx=window_get_width();
global.inicy=window_get_height();
aspect_ratio=global.inicx/global.inicy
if aspect_ratio<(1/0.65){aspect_ratio=1/0.65}
if aspect_ratio>(1/0.45){aspect_ratio=1/0.45}

var maxy=347;
if room=rm_main{maxy=347}else if room=rm_test{maxy=300}
camera_set_view_size(view_camera[0],maxy*aspect_ratio,maxy) //190
surface_resize(application_surface,720*aspect_ratio,720)//comentar cuando este para windows

global.razx=(720*aspect_ratio)/1280;
}