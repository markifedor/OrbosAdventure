main_color = #09f2a0;
outer_color = color_shift_hsv(main_color, 5, 5, -50);
outline_color = color_shift_hsv(main_color, 8, 7, -85);

_tile_height = -1;
_room_width = -1;
_room_height = -1;

move_dist = 1;
pos = [-1, -1];
pos_before_move = [-1, -1];
dir = [0, 0];
targetTilePos = [-1, -1];
moveBuffer = ds_queue_create();

steps = -1;
radius = -1;

squish_counter = 0;
_draw_y = y;
slime_surf = -1;
squishiness = .025;
_xScale = 1;
_yScale = 1;
_y_offset = 0;
_rotation = 0;

face_sprite = spr_face_neutral;
face_rot = 0;

is_moving = false;
changedTarget = false;

is_slipping = false;
final_slip = false;
is_fiery = false;
was_fiery_before_move = false; 

is_wall_bumping = false;
bump_dir_x = 0;
bump_dir_y = 0;

is_dying = false;

controller = noone;
other_player = noone;
in_use = false;