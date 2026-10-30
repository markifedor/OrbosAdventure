if (!in_use){
    return;
}

if (is_dying) {
    changePlayerSteps(id, controller, steps div 2);
}

if (steps == 0) {
    in_use = false;
    if (!other_player.in_use){
        controller.roomFailed = true;
    }
    return;
}

// Proccess inputs and add to buffer
if (!controller.roomFinished and !controller.roomFailed) {
    var dirPressed = [ 
        keyboard_check_released(ord("D")) - keyboard_check_released(ord("A")),
        keyboard_check_released(ord("S")) - keyboard_check_released(ord("W"))
    ];
   
    if (!array_equals(dirPressed, [0, 0])) {
        if (dirPressed[0] != 0 and dirPressed[1] != 0){
            ds_queue_enqueue(moveBuffer, [dirPressed[0], 0]);
            ds_queue_enqueue(moveBuffer, [0, dirPressed[1]]);
        }
        else {
            ds_queue_enqueue(moveBuffer, dirPressed);
        }
        show_debug_message($"Inputted {dirPressed}");
    }
}

// Update move animation
if(is_moving){
    update_tile_movement(controller, id);
    if(!is_moving and pos != pos_before_move){
        pos_before_move = pos;
    }
    
    return;
}

if (id == controller.player and other_player.in_use){
    if (array_equals(other_player.pos, pos)){
        changePlayerSteps(id, controller, steps + other_player.steps)
        other_player.in_use = false;
        handleSelfUpdatingTiles(controller);
    }
}
// Use buffered inputs
if (!is_slipping and !controller.roomFinished and !controller.roomFailed) { 
    dir = [0, 0];
    if (ds_queue_size(moveBuffer) > 0){
        dir = ds_queue_dequeue(moveBuffer);
        targetTilePos = [pos[0]+dir[0], pos[1]+dir[1]];
        
        if(!canMoveToTargetTile(controller, id)) {
            is_wall_bumping = true;
            
            //if (dir[1] > 0) sprite_index = spr_player_walk_down;
            //if (dir[1] < 0) sprite_index = spr_player_walk_up;
            //if (dir[0] > 0) sprite_index = spr_player_walk_right;
            //if (dir[0] < 0) sprite_index = spr_player_walk_left;
        }
        move_to_tile(controller, id);
    }
}

//if (sprite_index == spr_player_walk_down) sprite_index = spr_player_idle_down;
//if (sprite_index == spr_player_walk_up) sprite_index = spr_player_idle_up;
//if (sprite_index == spr_player_walk_right) sprite_index = spr_player_idle_right;
//if (sprite_index == spr_player_walk_left) sprite_index = spr_player_idle_left;
