if (!in_use) { return; }

var _target_fps = game_get_speed(gamespeed_fps);

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

var outlineSize = 2;
if (radius < 8) {
    outlineSize = 1.5;
}
if (radius < 6) {
    outlineSize = 1;
}

var _max_scale = 1 + (squishiness * 2);
var _max_radius = (radius + outlineSize) * _max_scale;

var _surf_size = ceil(_max_radius * 2) + 8;
var _center = _surf_size * 0.5;

if (!surface_exists(slime_surf) || surface_get_width(slime_surf) < _surf_size) {
    if (surface_exists(slime_surf)) {
        surface_free(slime_surf);
    }
    slime_surf = surface_create(_surf_size, _surf_size);
}

// 2. Render circles with bottom edge aligned to bottom padding
surface_set_target(slime_surf);
draw_clear_alpha(c_black, 0);

var hueShift = 0;
if (other_player.in_use) {
    if (id == controller.player) {
        hueShift -= 10;
    }
    if (id == controller.copyPlayer) {
        hueShift += 10;
    }
}
var draw_outline_color = color_shift_hsv(outline_color, hueShift, 0, 0);
var draw_main_color    = color_shift_hsv(main_color, hueShift, 0, 0);
var draw_outer_color   = color_shift_hsv(outer_color, hueShift, 0, 0);

var _bottom_y = _surf_size - outlineSize - 2;

draw_set_color(draw_outline_color);
draw_circle(_center, _bottom_y - radius, radius + outlineSize, false);

draw_circle_colour(_center, _bottom_y - radius, radius, draw_main_color, draw_outer_color, false);
surface_reset_target();

// 3. Transform surface using GPU Matrix (anchors pivot directly to bottom floor pixel)

// Save current world matrix
var _matrix_prev = matrix_get(matrix_world);

// Build matrix: Move pivot (_center, _bottom_y) to (0,0), apply scale/rotation, then translate to room (x, _draw_y)
var _matrix_transform = matrix_build(x, _draw_y, 0, 0, 0, _rotation, _xScale, _yScale, 1);
matrix_set(matrix_world, _matrix_transform);

// Draw surface relative to local pivot (0,0)
draw_surface(slime_surf, -_center, -_bottom_y);

// Restore original world matrix
matrix_set(matrix_world, _matrix_prev);