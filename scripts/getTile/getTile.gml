function getTile(controller, pos){
    var targetTile = controller.tiles[# pos[0], pos[1]];
        
    var targetOverlayTile = controller.overlayTiles[# pos[0], pos[1]]
    
    if (typeof(targetTile) != "struct"){
        return false;
    }
    
    // Check Properties of Tile (and OverlayTile)
    var props = targetTile[$ "properties"];
    var overlayProps = undefined;
    
    var overlayExists = false;
    if (typeof(targetOverlayTile) == "struct"){
        overlayExists = true;
        overlayProps = targetOverlayTile[$ "properties"];
    }
    
    return [targetTile, props, overlayExists, targetOverlayTile, overlayProps]
}