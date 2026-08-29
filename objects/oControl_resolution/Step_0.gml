if (act=0){
//act=1

global.inicx=window_get_width();
global.inicy=window_get_height();
aspect_ratio=global.inicx/global.inicy
if aspect_ratio<(1/0.65){aspect_ratio=1/0.65}
if aspect_ratio>(1/0.45){aspect_ratio=1/0.45}

var maxy=347;    
if os_type=os_windows
{
if room=rm_main{maxy=347}else if room=rm_plantilla{maxy=300} // PC
}
else if os_type=os_android or os_type = os_ios
{
if room=rm_main{maxy=300}else if room=rm_plantilla{maxy=300} // PC    
}      
camera_set_view_size(view_camera[0],maxy*aspect_ratio,maxy) //190
    
var _w = max(1, floor(720 * aspect_ratio));
var _h = 720;

if (surface_get_width(application_surface) != _w || surface_get_height(application_surface) != _h) {
    surface_resize(application_surface, _w, _h);
}

global.razx=(720*aspect_ratio)/1280;
}