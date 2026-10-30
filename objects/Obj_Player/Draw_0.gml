if(!in_use){ return; }

var _target_fps = game_get_speed(gamespeed_fps);

if (!is_moving){
    squish_counter++;
    if (squish_counter mod 5 == 0){
        var squish_amount = squishiness*cos(squish_counter*(2*pi)/_target_fps);
        
        _xScale = 1+squishiness + squish_amount;
        _yScale = 1-squishiness - squish_amount;
        _y_offset = -radius * (_yScale - 1);
        _draw_y = y + _y_offset;
    }
} else {
  _draw_y = y + _y_offset;
}


var outlineSize = 2;
if (radius < 8){
    outlineSize = 1.5;
}
if (radius < 6){
    outlineSize = 1;
}

var _max_scale = 1 + (squishiness * 2);
var _max_radius = (radius + outlineSize) * _max_scale;

var _surf_size = ceil(_max_radius * 2) + 8;
var _center = _surf_size * 0.5;

if (!surface_exists(slime_surf) || surface_get_width(slime_surf) < _surf_size) {
    if (surface_exists(slime_surf)) {
        surface_free(slime_surf); // Free old smaller surface when level changes radius
    }
    slime_surf = surface_create(_surf_size, _surf_size);
}

// 2. Render circles relative to surface center
surface_set_target(slime_surf);
draw_clear_alpha(c_black, 0); // Clear background

var hueShift = 0;
if (other_player.in_use){
    if (id == controller.player){
        hueShift -= 10;
    }
    if (id == controller.copyPlayer){
        hueShift += 10;
    }
}
var draw_outline_color = color_shift_hsv(outline_color, hueShift, 0, 0);
var draw_main_color = color_shift_hsv(main_color, hueShift, 0, 0);
var draw_outer_color = color_shift_hsv(outer_color, hueShift, 0, 0);

draw_set_color(draw_outline_color);
draw_circle(_center, _center, radius + outlineSize, false);

draw_circle_colour(_center, _center, radius, draw_main_color, draw_outer_color, false);
surface_reset_target();

// 3. Draw the surface stretched/squashed around origin

draw_surface_ext(
    slime_surf,
    x - (_center * _xScale), 
    _draw_y - (_center * _yScale), 
    _xScale, 
    _yScale, 
    _rotation, 
    c_white, 
    1
);