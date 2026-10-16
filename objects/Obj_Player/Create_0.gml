_tile_height = -1;
_room_width = -1;
_room_height = -1;

move_dist = 1;
pos = [-1, -1];
dir = [0, 0];
targetTilePos = [-1, -1];
moveBuffer = ds_queue_create();
steps = -1;
max_steps = 16;
is_moving = false;
is_slipping = false;

controller = noone;