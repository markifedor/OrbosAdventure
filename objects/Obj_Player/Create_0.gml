main_color = #2DE5A4;
outer_color = color_shift_hsv(main_color, 5, 5, -40);
outline_color = color_shift_hsv(main_color, 8, 7, -75);

_tile_height = -1;
_room_width = -1;
_room_height = -1;

move_dist = 1;
pos = [-1, -1];
dir = [0, 0];
targetTilePos = [-1, -1];
moveBuffer = ds_queue_create();

steps = -1;
radius = -1;
max_steps = 16;

squish_counter = 0;
_draw_y = y;
slime_surf = -1;
squishiness = .025;
_xScale = 1;
_yScale = 1;
_y_offset = 0;
_rotation = 0;

is_moving = false;
changedTarget = false;

is_slipping = false;

is_wall_bumping = false;
bump_dir_x = 0;
bump_dir_y = 0;

is_dying = false;

controller = noone;
ready = false;