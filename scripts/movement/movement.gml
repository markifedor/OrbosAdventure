/// @function move_to_tile(inst, target_grid_x, target_grid_y, duration, curve_asset)
function move_to_tile(controller, _inst) {
    if (_inst.is_moving) return false; // Already moving
    
    with (_inst) {
        is_moving = true;
        move_timer = 0;
        move_duration = 15;
        curve_asset = Curve_Move;
        
        start_x = x;
        start_y = y;
        
        var grid_x = targetTilePos[0];
        var grid_y = targetTilePos[1];
        
        target_x = grid_x * controller.TILE_HEIGHT+controller.TILE_HEIGHT*.5;
        target_y = grid_y * controller.TILE_HEIGHT+controller.TILE_HEIGHT*.5;
    }
    
    return true;
}

/// @function update_tile_movement(inst)
function update_tile_movement(controller, _inst) {
    with (_inst) {
        if (!is_moving) return;
        
        move_timer++;
        var _progress = clamp(move_timer / move_duration, 0, 1);
        
        var _channel = animcurve_get_channel(curve_asset, "move");
        var _curve_val = animcurve_channel_evaluate(_channel, _progress);
        
        x = lerp(start_x, target_x, _curve_val);
        y = lerp(start_y, target_y, _curve_val);
        
        if (move_timer == int64(move_duration/3)){
            // Trigger out mechanics
            handleCurrentTile(controller, id);
        }
        
        if (move_timer == int64(move_duration*.6)){
            // Trigger in mechanics
            handleTargetTile(controller, id);
        }
        
        if (_progress >= 1.0) {
            x = target_x;
            y = target_y;
            is_moving = false;
            pos = targetTilePos;
        }
    }
}
