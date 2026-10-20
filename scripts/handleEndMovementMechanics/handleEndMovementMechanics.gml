function handleEndMovementMechanics(controller, player) {
    //show_debug_message("Doing end movement mechanics");
    with (player) {
        if (is_undefined(player)){
            return;
        }
        var currentOverlayTile = controller.overlayTiles[# pos[0], pos[1]];
        var overlayProps = undefined;
        
        if (is_struct(currentOverlayTile)) {
            overlayProps = currentOverlayTile[$ "properties"];
            var slipToNextTile = overlayProps[$ "slipToNextTile"];
            
            if (!is_undefined(slipToNextTile) && slipToNextTile) {
                targetTilePos = [pos[0] + dir[0], pos[1] + dir[1]];
                
                if (canMoveToTargetTile(controller, id) and !player.is_dying) {
                    // Valid slide onto ice or normal ground: reset bump flags
                    is_slipping = true;
                    is_wall_bumping = false; 
                    move_to_tile(controller, id);
                }
                else if (!is_wall_bumping) {
                    // Slide directly into a wall: set bump flag and calculate bump target
                    is_slipping = false;
                    is_wall_bumping = true;
                    move_to_tile(controller, id);
                }
            }
        }    
    }
}