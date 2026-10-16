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
    }
    return true;
}

function handleTargetTile(controller, player){
    with (player) {
        // Obtain Tile
        var targetTile = controller.tiles[# targetTilePos[0], targetTilePos[1]];
        if (!canMoveToTargetTile(controller, player)){
            return;
        }
        
        var targetOverlayTile = controller.overlayTiles[# targetTilePos[0], targetTilePos[1]]
        
        if (typeof(targetTile) != "struct"){
            return false;
        }
        
        // Check Properties of Tile (and OverlayTile)
        var props = targetTile[$ "properties"];
        var overlayProps;
        
        var ignoreSteps = false;
        
        if (!is_undefined(props[$ "ignoreSteps"])){
            ignoreSteps = props[$ "ignoreSteps"];
        }
        
        
        var overlayExists = false;
        if (typeof(targetOverlayTile) == "struct"){
            overlayExists = true;
            overlayProps = targetOverlayTile[$ "properties"];
            if (!is_undefined(overlayProps[$ "ignoreSteps"])){
                // overlay overrides normal ignore steps properties
                ignoreSteps = overlayProps[$ "ignoreSteps"];
            }
        }
        
        if (!is_undefined(props[$ "stepsIn"]) and !ignoreSteps){
            player.steps += props[$ "stepsIn"];
        }
        
        // Handle Level Finish
        if (overlayExists and !is_undefined(overlayProps[$ "finish"]) and overlayProps[$ "finish"] == true){
            controller.roomFinished = true;
            targetTile = variable_clone(targetTile);
            props[$ "convertOnIn"] = overlayProps[$ "convertOnIn"]
        }
        
        var convertOnIn = props[$ "convertOnIn"];
        if (!is_undefined(convertOnIn)){
            var newLook;
            if (is_real(convertOnIn)){
                newLook = convertOnIn;
            } else {
                targetTile = controller._csv_to_tile_struct[$ convertOnIn];
                newLook = targetTile[$ "look"];
                controller.tiles[# targetTilePos[0], targetTilePos[1]] = targetTile;
            }
            
            tilemap_set(controller._tilemap_id, newLook, targetTilePos[0], targetTilePos[1]);
        }
        
        return true;
    }
}

function handleSlimingIn(controller, player){
    with (player) {
        var targetTile = controller.tiles[# targetTilePos[0], targetTilePos[1]];
        var props = targetTile[$ "properties"];
        
        var targetOverlayTile = controller.overlayTiles[# targetTilePos[0], targetTilePos[1]];
        var overlayProps = targetOverlayTile[$ "properties"];
        
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