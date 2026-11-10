if (!in_use) { return; }

var _target_fps = game_get_speed(gamespeed_fps);

if (steps < 2){
    face_sprite = spr_face_smol;
}
else if (is_dying or is_wall_bumping){
    face_sprite = spr_face_pain;
}
else if (is_slipping){
    face_sprite = spr_face_joyous;   
}
else if (is_fiery) {
    face_sprite = spr_face_fiery;
}
else {
    face_sprite = spr_face_neutral;
}

if (!is_moving) {
    squish_counter++;
    if (squish_counter mod 5 == 0) {
        var squish_amount = squishiness * cos(squish_counter * (2 * pi) / _target_fps);
        
        _xScale = 1 + squishiness + squish_amount;
        _yScale = 1 - squishiness - squish_amount;
        _y_offset = -radius * (_yScale - 1);
        _draw_y = y + _y_offset;
    }
} else {
    _draw_y = y + _y_offset;
}

var outlineSize;
if (radius < 8) { outlineSize = 1; }
else { outlineSize = 2; }

var _max_scale = 1 + (squishiness * 2);
var _max_radius = ceil((radius + outlineSize) * _max_scale);

// 2. Explicitly measure the face sprite dimensions (not the object sprite!)
var _face_w = sprite_get_width(face_sprite);
var _face_h = sprite_get_height(face_sprite);

// 3. Ensure surface size provides ample margin so rotated face bounds never hit X = 0 or X = _surf_size
var _calculated_size = max(_max_radius * 2, _face_w, _face_h) + 24;
var _raw_size = max(32, _calculated_size);

// Force surf_size to be an even integer
var _surf_size = (_raw_size mod 2 == 0) ? _raw_size : _raw_size + 1;
var _center_x = _surf_size div 2;

if (!surface_exists(slime_surf) || surface_get_width(slime_surf) < _surf_size) {
    if (surface_exists(slime_surf)) {
        surface_free(slime_surf);
    }
    slime_surf = surface_create(_surf_size, _surf_size);
}

// 4. Target Surface Rendering
surface_set_target(slime_surf);
draw_clear_alpha(c_black, 0);

var orboColors = getOrboColors(id);
var draw_outline_color = orboColors[0];
var draw_main_color    = orboColors[1];
var draw_outer_color   = orboColors[2];

// Anchored bottom floor line
var _bottom_y = _surf_size - outlineSize - 4;
var _circle_y = _bottom_y - radius;

draw_set_color(draw_outline_color);
draw_circle(_center_x, _circle_y, radius + outlineSize, false);
draw_circle_colour(_center_x, _circle_y, radius, draw_main_color, draw_outer_color, false);

if (array_equals(dir, [ 1, 0])) { face_rot = 90;  }
if (array_equals(dir, [ 0, 1])) { face_rot = 0;   }
if (array_equals(dir, [-1, 0])) { face_rot = 270; }
if (array_equals(dir, [ 0,-1])) { face_rot = 180; }

// Integer Y anchor for face sprite
var face_y = _bottom_y - (radius * 2 div 3);

draw_sprite_ext(face_sprite, 0, _center_x, face_y, 1, 1, face_rot, c_white, 1);

surface_reset_target();
draw_set_color(c_white);

// 5. GPU Matrix World Transform
var _matrix_prev = matrix_get(matrix_world);

var _matrix_transform = matrix_build(x, _draw_y, 0, 0, 0, _rotation*2, _xScale, _yScale, 1);
matrix_set(matrix_world, _matrix_transform);

draw_surface(slime_surf, -_center_x, -_bottom_y);

matrix_set(matrix_world, _matrix_prev);