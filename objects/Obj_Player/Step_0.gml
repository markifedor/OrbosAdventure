//if (!ready){
//    return
//}

image_xscale = (3*sqrt(steps)+2)/max_steps;
image_yscale = image_xscale;

// Proccess inputs and add to buffer
if (!controller.roomFinished and !controller.roomFailed) {
    keyPressed = false;
    var dirPressed = [ 
        keyboard_check_released(ord("D")) - keyboard_check_released(ord("A")),
        keyboard_check_released(ord("S")) - keyboard_check_released(ord("W"))
    ];
   
    if (!array_equals(dirPressed, [0, 0])) {
        keyPressed = true;
    }
    if (dirPressed[0] != 0){
        dirPressed[1] = 0; // prevent diagonal movement
    }
   
    if (keyPressed){
        ds_queue_enqueue(moveBuffer, dirPressed);
        show_debug_message($"Inputted {dirPressed}");
    }
}

// Update move animation
if(is_moving){
    update_tile_movement(controller, id);
    return;
}    

// Use buffered inputs
if (!controller.roomFinished and !controller.roomFailed) {  
    var dir = [0, 0];
    if (ds_queue_size(moveBuffer) > 0){
        handleSelfUpdatingTiles(controller, id);
        
        dir = ds_queue_dequeue(moveBuffer);
        targetTilePos = [pos[0]+dir[0], pos[1]+dir[1]];
        
        if(canMoveToTargetTile(controller, id)) {
            //show_debug_message($"Moving to tile {targetTilePos}");
            move_to_tile(controller, id);
            
            if (dir[1] > 0) sprite_index = spr_player_walk_down;
            if (dir[1] < 0) sprite_index = spr_player_walk_up;
            if (dir[0] > 0) sprite_index = spr_player_walk_right;
            if (dir[0] < 0) sprite_index = spr_player_walk_left;
            
            return;
       }
    }
}

if (steps == 0) {
    controller.roomFailed = true;
    instance_destroy();
    return;
}

if (sprite_index == spr_player_walk_down) sprite_index = spr_player_idle_down;
if (sprite_index == spr_player_walk_up) sprite_index = spr_player_idle_up;
if (sprite_index == spr_player_walk_right) sprite_index = spr_player_idle_right;
if (sprite_index == spr_player_walk_left) sprite_index = spr_player_idle_left;
