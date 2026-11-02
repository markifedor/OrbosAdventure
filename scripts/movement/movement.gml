/// @function move_to_tile(inst, target_grid_x, target_grid_y, duration, pos_curve_asset)
function move_to_tile(controller, player) {
    if (player.is_moving) return false; // Already moving
    
    with (player) {
        is_moving = true;
        is_travelling = true;
        move_timer = 0;
        move_duration = 13;
        pos_curve_asset = Curve_Move;
        pos_curve_channel = "move";
        
        squash_stretch_curve_asset = Curve_Squash_Stretch;
        xScale_curve_channel = "move_xScale"
        yScale_curve_channel = "move_yScale"
        if (abs(dir[0]) == 1){
            xScale_curve_channel = "move_yScale"
            yScale_curve_channel = "move_xScale"
        }
        rotation_curve_channel = "move_rotation"
        
        start_x = x;
        start_y = y;
        
        var targetCoors = getCorrectPlayerCoors(controller, targetTilePos, radius, true);
        target_x = targetCoors[0];
        target_y = targetCoors[1];
        
        var _next_dir = ds_queue_head(moveBuffer);
        if (!ds_queue_empty(moveBuffer) && array_equals(_next_dir, dir)) {
            pos_curve_channel = "iceContinue";
            xScale_curve_channel = "iceContinue_xScale";
            yScale_curve_channel = "iceContinue_yScale";
            rotation_curve_channel = "iceContinue_rotation";
            move_duration = 6;
       }
        
        if (is_wall_bumping){
            show_debug_message("Doing wall bump!");
            pos_curve_channel = "wallBump";
            if (abs(dir[1]) == 1){
                xScale_curve_channel = "bump_yScale"
                yScale_curve_channel = "bump_xScale"
            } else {
                xScale_curve_channel = "bump_xScale"
                yScale_curve_channel = "bump_yScale"
            }
            rotation_curve_channel = "bump_rotation"
            is_travelling = false;
            is_slipping = false;
            return true;
        }
        
        var currentOverlayTile = controller.overlayTiles[# pos[0], pos[1]];
        var currentOverlayProps = undefined;
        if (!is_undefined(currentOverlayTile)){
            currentOverlayProps = currentOverlayTile[$ "properties"];    
        }
         
        var targetOverlayTile = controller.overlayTiles[# targetTilePos[0], targetTilePos[1]];
        var targetOverlayProps = undefined;
        if (!is_undefined(targetOverlayTile)){
            targetOverlayProps = targetOverlayTile[$ "properties"];
        }
        
        var slippingProperty = "slipToNextTile";
        if(is_fiery){
            slippingProperty = "slipToNextTileFiery";
        }
        
        show_debug_message($"slippingProperty: {slippingProperty}");
        
        var currentSlips = false
        if (!is_undefined(currentOverlayProps)){
            if (!is_undefined(currentOverlayProps[$ slippingProperty])){
                currentSlips = currentOverlayProps[$ slippingProperty];
            }
        }
        
        var targetSlips = false
        if (!is_undefined(targetOverlayProps)){
            if (!is_undefined(targetOverlayProps[$ slippingProperty])){
                targetSlips = targetOverlayProps[$ slippingProperty];
            }
        }
        
        show_debug_message($"currentSlips: {currentSlips}");
        show_debug_message($"targetSlips: {targetSlips}");
            
        if (targetSlips){
            show_debug_message("we're slipping");
            if (is_slipping){
                pos_curve_channel = "iceContinue";
                xScale_curve_channel = "iceContinue_xScale";
                yScale_curve_channel = "iceContinue_yScale";
                rotation_curve_channel = "iceContinue_rotation";
                move_duration = 4;
            }
            else {
                pos_curve_channel = "iceMoveStart";
                is_slipping = true;
                move_duration = 8;
            }
        }
        else if (currentSlips){
            pos_curve_channel = "iceMoveEnd";
            is_slipping = false;
        }    
    }
    
    show_debug_message(player.pos_curve_channel);
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
        
        var _xScale_channel = animcurve_get_channel(squash_stretch_curve_asset, xScale_curve_channel);
        _xScale = animcurve_channel_evaluate(_xScale_channel, _progress);
        
        var _yScale_channel = animcurve_get_channel(squash_stretch_curve_asset, yScale_curve_channel);
        _yScale = animcurve_channel_evaluate(_yScale_channel, _progress);
        
        var _rotation_channel = animcurve_get_channel(squash_stretch_curve_asset, rotation_curve_channel);
        _rotation = dir[0] * animcurve_channel_evaluate(_rotation_channel, _progress);    
        
        
        if (is_travelling and move_timer == int64(move_duration*.1)){
            // Trigger out mechanics
            handleCurrentTile(controller, id);
        }
        
        if (is_travelling and move_timer == int64(move_duration*.5)){
            // Trigger in mechanics
            handleTargetTile(controller, id);
            start_y = y - (dir[1] * _pos_curve_val * controller.TILE_HEIGHT);
        }
        
        if (is_travelling and move_timer == int64(move_duration*.6)){
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
                handleSelfUpdatingTiles(controller);
                handleEndMovementMechanics(controller, id);
                
                var playerNum = id == controller.player ? 1 : 2;
                show_debug_message($"Player {playerNum} steps: {steps}"); 
                return;
            }
            is_wall_bumping = false;
        }
    }
}


