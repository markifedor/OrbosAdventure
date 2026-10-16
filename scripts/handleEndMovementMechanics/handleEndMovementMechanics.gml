function handleEndMovementMechanics(controller, player){
    show_debug_message("Doing end movement mechanics");
    with (player){
        var currentOverlayTile = controller.overlayTiles[# pos[0], pos[1]];
        
        var overlayProps = undefined;
        
        if (typeof(currentOverlayTile) == "struct"){
            show_debug_message("overlayExists!");
            overlayProps = currentOverlayTile[$ "properties"]
        
            var slipToNextTile = overlayProps[$ "slipToNextTile"];
            if (!is_undefined(slipToNextTile) and slipToNextTile){
                show_debug_message($"Sliping in dir: {dir}");
                targetTilePos = [pos[0] + dir[0], pos[1] + dir[1]];
                if(canMoveToTargetTile(controller, id)) {
                    is_slipping = true;
                    move_to_tile(controller, player);
                }
                else{
                    is_slipping = false;
                }
            }
        }   
    }
}