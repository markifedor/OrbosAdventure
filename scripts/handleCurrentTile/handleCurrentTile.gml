function handleCurrentTile(controller, player){
    var currentTile = controller.tiles[# player.pos[0], player.pos[1]];
    var currentOverlayTile = controller.overlayTiles[# player.pos[0], player.pos[1]];
    
    var overlayExists = false;
    
    if (typeof(currentTile) != "struct"){
        return;
    }
    if (typeof(currentOverlayTile) == "struct"){
        overlayExists = true;
    }
    
    var props = currentTile[$ "properties"];
    var overlayProps;
    
    
    var ignoreSteps = false;
    
    if (overlayExists){
        overlayProps = currentOverlayTile[$ "properties"];
        ignoreSteps = overlayProps[$ "ignoreSteps"];
    }
        
    var stepsOut = props[$ "stepsOut"];
    if (!is_undefined(stepsOut) and !ignoreSteps){
        player.steps += stepsOut;
    }
    
    var convertOnOut = props[$ "convertOnOut"];
    if (!is_undefined(convertOnOut)){
        currentTile = controller._csv_to_tile_struct[$ convertOnOut];
        props = currentTile[$ "properties"];
        
        tilemap_set(controller._tilemap_id, currentTile[$ "look"], player.pos[0], player.pos[1]);
        controller.tiles[# player.pos[0], player.pos[1]] = currentTile;
    }
    
    var slimedOut = props[$ "slimedOut"];
    if (overlayExists){
        var overlaySlimedOut = overlayProps[$ "slimedOut"];
        if (!is_undefined(overlaySlimedOut)){
            slimedOut = overlaySlimedOut; // Overlay determines Sliming properties
        }
    }
    
    if(!is_undefined(slimedOut) and slimedOut){
        controller.overlayTiles[# player.pos[0], player.pos[1]] = controller._csv_to_tile_struct[$ "L"];
        currentOverlayTile = controller.overlayTiles[# player.pos[0], player.pos[1]];
        tilemap_set(controller._overlay_tilemap_id, currentOverlayTile[$ "look"], player.pos[0], player.pos[1]);
    }   
}