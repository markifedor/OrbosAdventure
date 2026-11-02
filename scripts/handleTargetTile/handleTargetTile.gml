function canMoveToTargetTile(controller, player){
    with (player){
        if (array_equals(targetTilePos, pos)){
            return false;
        }
        
        var targetTile = controller.tiles[# targetTilePos[0], targetTilePos[1]]
        if (typeof(targetTile) != "struct"){
            return false;
        }
        
        if (targetTile[$ "properties"][$ "blockMovement"] == true){
            return false;
        }
        
        var directionAllowSplit = targetTile[$ "properties"][$ "directionAllowSplit"];
        show_debug_message(directionAllowSplit);
        if (!is_undefined(directionAllowSplit)){
            
            switch(directionAllowSplit){
                case "^":
                    return array_equals(dir, [0, 1]);
                case ">":
                    return array_equals(dir, [-1, 0]);
                case "v":
                    return array_equals(dir, [0, -1]);
                case "<":
                    return array_equals(dir, [1, 0]);
            }
        }
    }
    return true;
}

function handleTargetTile(controller, player){
    with (player) {
        if (!canMoveToTargetTile(controller, player)){
            return;
        }
        
        // Obtain Tile
        
        var tileVars = getTile(controller, player.targetTilePos);
        var targetTile = tileVars[0];
        var props = tileVars[1];
        var overlayExists = tileVars[2];
        var targetOverlayTile = tileVars[3];
        var overlayProps = tileVars[4];
        
        var ignoreSteps = getTileProperty("ignoreSteps", targetTile, overlayExists, targetOverlayTile);
        
        var ignoreStepsFiery = getTileProperty("ignoreStepsFiery", targetTile, overlayExists, targetOverlayTile);
        
        if (is_fiery and !is_undefined((ignoreStepsFiery))){
            ignoreSteps = ignoreStepsFiery;
        }
        
        var killsOnIn = getTileProperty("killsOnIn", targetTile, overlayExists, targetOverlayTile);
        if (!is_undefined(killsOnIn) and killsOnIn){
            is_dying = true;
        }
        
        var splitsOnIn = props[$ "splitsOnIn"];
        if (!is_undefined(splitsOnIn) and splitsOnIn){
            var directionAllowSplit = props[$ "directionAllowSplit"];
            if (is_undefined(directionAllowSplit)){
                show_error($"Mirror shard at {targetTilePos} does not have a direction.", true);
            }
            
            copyAllPlayerProperties(player, player.other_player);
            
            changePlayerSteps(player.other_player, controller, steps div 2);
            
            if (steps mod 2 == 0){
                changePlayerSteps(player, controller, steps div 2);
            } else {
                changePlayerSteps(player, controller, steps div 2 + 1); 
            }
            
            switch(directionAllowSplit){
                case "^":
                    controller.copyPlayer.targetTilePos[0] -= 1;
                    player.targetTilePos[0] += 1;
                    break;
                case ">":
                    controller.copyPlayer.targetTilePos[1] -= 1;
                    player.targetTilePos[1] += 1;
                    break;
                case "v":
                    controller.copyPlayer.targetTilePos[0] += 1;
                    player.targetTilePos[0] -= 1;
                    break;
                case "<":
                    controller.copyPlayer.targetTilePos[1] += 1;
                    player.targetTilePos[1] -= 1;
                    break;
            }
            controller.copyPlayer.changedTarget = true;
            changedTarget = true;
            handleTargetTile(controller, player);
            handleTargetTile(controller, controller.copyPlayer);
            return;
        }
        
        var ignoreConvertOnIn = false; 
        var causesFieryEffect = getTileProperty("causesFieryEffect", targetTile, overlayExists, targetOverlayTile);
        if (!is_undefined(causesFieryEffect) and causesFieryEffect){
            if (player.is_fiery){
                ignoreConvertOnIn = true;
            }
            else{
                player.is_fiery = true;
            }
        }
        
        var convertOnInFiery = getTileProperty("convertOnInFiery", targetTile, overlayExists, targetOverlayTile);
        if (!is_undefined(convertOnInFiery) and player.is_fiery){
            player.is_fiery = false;
            readInCSVTile(controller, convertOnInFiery, targetTilePos[0], targetTilePos[1]);
            handleTargetTile(controller, player);
            return;
        }
        
        var stepsIn = getTileProperty("stepsIn", targetTile, overlayExists, targetOverlayTile, true);
        if (!is_undefined(stepsIn) and !ignoreSteps){
            changePlayerSteps(player, controller, player.steps + stepsIn);
        }
        
        // Handle Level Finish
        if (overlayExists and !is_undefined(overlayProps[$ "finish"]) and overlayProps[$ "finish"]){
            controller.roomFinished = true;
            targetTile = variable_clone(targetTile);
            props[$ "convertOnIn"] = overlayProps[$ "convertOnIn"]
        }
        
        var convertOnIn = getTileProperty("convertOnIn", targetTile, overlayExists, targetOverlayTile);
        if (!is_undefined(convertOnIn) and !ignoreConvertOnIn){
            readInCSVTile(controller, convertOnIn, targetTilePos[0], targetTilePos[1]);
            tileVars = getTile(controller, player.targetTilePos);
        }
        
        return true;
    }
}

function handleSlimingIn(controller, player){
    with (player) {
        var targetTile = controller.tiles[# targetTilePos[0], targetTilePos[1]];
        var props = undefined;
        if (!is_undefined(targetTile)){
            props = targetTile[$ "properties"];
        }
        
        var targetOverlayTile = controller.overlayTiles[# targetTilePos[0], targetTilePos[1]];
        var overlayProps = undefined;
        if (!is_undefined(targetOverlayTile)){
            overlayProps = targetOverlayTile[$ "properties"];
        }
            
        var overlayExists = false;
        if (typeof(targetOverlayTile) == "struct"){
            overlayExists = true;
        }
        
        var slimedIn = props[$ "slimedIn"];
        if (overlayExists){
            var overlaySlimedIn = overlayProps[$ "slimedIn"];
            if (!is_undefined(overlaySlimedIn)){
                slimedIn = overlaySlimedIn; // Overlay determines Sliming properties
            }
        }
        
        if(!is_undefined(slimedIn) and slimedIn){
            controller.overlayTiles[# targetTilePos[0], targetTilePos[1]] = controller._csv_to_tile_struct[$ "L"];
            currentOverlayTile = controller.overlayTiles[# targetTilePos[0], targetTilePos[1]];
            tilemap_set(controller._overlay_tilemap_id, currentOverlayTile[$ "look"], targetTilePos[0], targetTilePos[1]);
        }
    }
}