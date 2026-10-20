/// @function move_to_tile(inst, target_grid_x, target_grid_y, duration, pos_curve_asset)
function move_to_tile(controller, player) {
    if (player.is_moving) return false; // Already moving
    
    with (player) {
        is_moving = true;
        is_travelling = true;
        move_timer = 0;
        move_duration = 15;
        pos_curve_asset = Curve_Move;
        pos_curve_channel = "move";
        
        squash_stretch_curve_asset = Curve_Squash_Stretch;
        xScale_curve_channel = "move_xScale"
        yScale_curve_channel = "move_yScale"
        rotation_curve_channel = "move_rotation"
        
        start_x = x;
        start_y = y;
        
        var targetCoors = getCorrectPlayerCoors(controller, targetTilePos, radius, true);
        target_x = targetCoors[0];
        target_y = targetCoors[1];
        
        var _next_dir = ds_queue_head(moveBuffer);
        if (!ds_queue_empty(moveBuffer) && array_equals(_next_dir, dir)) {
           pos_curve_channel = "iceContinue";
            move_duration = 8;
       }
        
        if (is_wall_bumping){
            show_debug_message("Doing wall bump!");
            pos_curve_channel = "wallBump";
            xScale_curve_channel = "bump_xScale"
            yScale_curve_channel = "bump_yScale"
            rotation_curve_channel = "bump_rotation"
            is_travelling = false;
            is_slipping = false;
            return true;
        }
        
        var currentOverlayProps = controller.overlayTiles[# pos[0], pos[1]][$ "properties"];
        var targetOverlayProps = controller.overlayTiles[# targetTilePos[0], targetTilePos[1]][$ "properties"];
        
        var currentSlips = false
        if (!is_undefined(currentOverlayProps) and !is_undefined(currentOverlayProps[$ "slipToNextTile"])){
            currentSlips = currentOverlayProps[$ "slipToNextTile"];
        }
         
        var targetSlips = false
        if (!is_undefined(targetOverlayProps) and !is_undefined(targetOverlayProps[$ "slipToNextTile"])){
            targetSlips = targetOverlayProps[$ "slipToNextTile"];
        }
            
        if (targetSlips){
            if (is_slipping){
                pos_curve_channel = "iceContinue";
                move_duration = 7;
            }
            else {
                pos_curve_channel = "iceMoveStart";
                is_slipping = true;
                move_duration = 10;
            }
        }
        else if (currentSlips){
            pos_curve_channel = "iceMoveEnd";
            is_slipping = false;
        }
        
    }
    
    show_debug_message(pos_curve_channel);
    return true;
}

/// @function update_tile_movement(inst)
function update_tile_movement(controller, player) {
    with (player) {
        if (!is_moving) return;
        if (changedTarget){
            var targetCoors = getCorrectPlayerCoors(controller, targetTilePos, radius, true);
            target_x = targetCoors[0];
            target_y = targetCoors[1];
            changedTarget = false;
            show_debug_message($"{player} changed target to {targetTilePos}");
        }
        
        move_timer++;
        var _progress = clamp(move_timer / move_duration, 0, 1);
        
        var _pos_channel = animcurve_get_channel(pos_curve_asset, pos_curve_channel);
        var _pos_curve_val = animcurve_channel_evaluate(_pos_channel, _progress);
        
        x = start_x + (target_x - start_x) * _pos_curve_val;
        y = start_y + (target_y - start_y) * _pos_curve_val;
        
        if (abs(dir[0]) == 1){
            var _xScale_channel = animcurve_get_channel(squash_stretch_curve_asset, xScale_curve_channel);
            _xScale = animcurve_channel_evaluate(_xScale_channel, _progress);
        
            var _yScale_channel = animcurve_get_channel(squash_stretch_curve_asset, yScale_curve_channel);
            _yScale = animcurve_channel_evaluate(_yScale_channel, _progress);
        
            var _rotation_channel = animcurve_get_channel(squash_stretch_curve_asset, rotation_curve_channel);
            _rotation = animcurve_channel_evaluate(_rotation_channel, _progress) * dir[0];    
        }
        else if (abs(dir[1]) == 1){
            var _xScale_channel = animcurve_get_channel(squash_stretch_curve_asset, xScale_curve_channel);
            _yScale = animcurve_channel_evaluate(_xScale_channel, _progress);
        
            var _yScale_channel = animcurve_get_channel(squash_stretch_curve_asset, yScale_curve_channel);
            _xScale = animcurve_channel_evaluate(_yScale_channel, _progress);
        
            var _rotation_channel = animcurve_get_channel(squash_stretch_curve_asset, rotation_curve_channel);
            _rotation = animcurve_channel_evaluate(_rotation_channel, _progress) * dir[0];    
        }
        
        if (is_travelling and move_timer == int64(move_duration*.1)){
            // Trigger out mechanics
            handleCurrentTile(controller, id);
        }
        
        if (is_travelling and move_timer == int64(move_duration*.6)){
            // Trigger in mechanics
            handleTargetTile(controller, id);
            start_y = y - (dir[1] * _pos_curve_val * controller.TILE_HEIGHT);
        }
        
        if (is_travelling and move_timer == int64(move_duration*.8)){
            // Trigger sliming
            handleSlimingIn(controller, id);
        }
        
        if (_progress >= 1.0) {
            if (is_travelling){
                pos = targetTilePos;
            }
            
            is_moving = false;
            is_travelling = false;
            
            correctedCoors = getCorrectPlayerCoors(controller, player.pos, player.radius, false);
            player.y = correctedCoors[1];
            if (!is_wall_bumping){
                handleSelfUpdatingTiles(controller, id);
                handleEndMovementMechanics(controller, id);
                return;
            }
            is_wall_bumping = false;
        }
    }
}


