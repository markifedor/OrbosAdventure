//if (!ready){
//    return
//}

image_xscale = (steps+3)/max_steps;
image_yscale = image_xscale;

if(is_moving){
    update_tile_movement(controller, id);
    return;
}

if (steps == 0) {
    controller.roomFailed = true;
    instance_destroy();
}

var dir = [ 
    keyboard_check_released(ord("D")) - keyboard_check_released(ord("A")),
    keyboard_check_released(ord("S"))-keyboard_check_released(ord("W"))
];

if (array_equals(dir, [0, 0])) {
    return;
}
else if (dir[0] != 0){
    dir[1] = 0; // prevent diagonal movement
}


targetTilePos = [pos[0]+dir[0], pos[1]+dir[1]];
if(canMoveToTargetTile(controller, id)) {
    show_debug_message($"Moving to tile {targetTilePos}");
    move_to_tile(controller, id);
}
else {
    return;
}

if (dir[0] != 0 or dir[1] != 0){
    if (dir[1] > 0) sprite_index = spr_player_walk_down;
    if (dir[1] < 0) sprite_index = spr_player_walk_up;
    if (dir[0] > 0) sprite_index = spr_player_walk_right;
    if (dir[0] < 0) sprite_index = spr_player_walk_left;
}
else{
    if (sprite_index == spr_player_walk_down) sprite_index = spr_player_idle_down;
    if (sprite_index == spr_player_walk_up) sprite_index = spr_player_idle_up;
    if (sprite_index == spr_player_walk_right) sprite_index = spr_player_idle_right;
    if (sprite_index == spr_player_walk_left) sprite_index = spr_player_idle_left;
}