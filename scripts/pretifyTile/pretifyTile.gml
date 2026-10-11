function doesTileMatch(tileNameToMatch, tile){
    if (!is_undefined(tile)){
        return tileNameToMatch == tile[$ "name"];
    }
    
    return true;
}

function pretifyTile(controller, _gx, _gy){
    with(controller){
        if (is_undefined(tiles[# _gx, _gy])){
            return;
        }
         
        var tileSetWidth = 32;
        
        var baseLook = tiles[# _gx, _gy][$ "look"];
        var tileName = tiles[# _gx, _gy][$ "name"];
        
        
        if (tileName == "room label"){
            return;
        }
        
        // --- VIGNETTE ---
        var vignetteCenter = tileSetWidth*3+1;
        
        // Check if neighboring tiles are out of bounds
        var vN  = doesTileMatch("", tiles[# _gx,     _gy - 1]);
        var vS  = doesTileMatch("", tiles[# _gx,     _gy + 1]);
        var vE  = doesTileMatch("", tiles[# _gx + 1, _gy    ]);
        var vW  = doesTileMatch("", tiles[# _gx - 1, _gy    ]);
        var vNW = doesTileMatch("", tiles[# _gx - 1, _gy - 1]);
        var vNE = doesTileMatch("", tiles[# _gx + 1, _gy - 1]);
        var vSW = doesTileMatch("", tiles[# _gx - 1, _gy + 1]);
        var vSE = doesTileMatch("", tiles[# _gx + 1, _gy + 1]);

        // -- Selecting Vignette Tile Look --
                
        if (vN && vW)       
            tilemap_set(_border_tilemap_id, vignetteCenter - tileSetWidth - 1, _gx, _gy); 
        else if (vN && vE)  
            tilemap_set(_border_tilemap_id, vignetteCenter - tileSetWidth + 1, _gx, _gy);
        else if (vS && vW)  
            tilemap_set(_border_tilemap_id, vignetteCenter + tileSetWidth - 1, _gx, _gy);
        else if (vS && vE)  
            tilemap_set(_border_tilemap_id, vignetteCenter + tileSetWidth + 1, _gx, _gy);
        else if (vN)        
            tilemap_set(_border_tilemap_id, vignetteCenter - tileSetWidth, _gx, _gy);
        else if (vS)        
            tilemap_set(_border_tilemap_id, vignetteCenter + tileSetWidth, _gx, _gy);
        else if (vW)        
            tilemap_set(_border_tilemap_id, vignetteCenter - 1, _gx, _gy);
        else if (vE)        
            tilemap_set(_border_tilemap_id, vignetteCenter + 1, _gx, _gy);
        
        
        // --- Autotiling ---
         
        if (tileName != "wall"){
            return;
        }
        
        // -- Check Surrounding Tiles Matches Type --
        var N, E, S, W, NE, NW, SE, SW;
        
        N = doesTileMatch(tileName, tiles[# _gx, _gy-1]);
        E = doesTileMatch(tileName, tiles[# _gx+1, _gy]);
        S = doesTileMatch(tileName, tiles[# _gx, _gy+1]);
        W = doesTileMatch(tileName, tiles[# _gx-1, _gy]);
        
        NE = doesTileMatch(tileName, tiles[# _gx+1, _gy-1]);
        NW = doesTileMatch(tileName, tiles[# _gx-1, _gy-1]);
        SE = doesTileMatch(tileName, tiles[# _gx+1, _gy+1]);
        SW = doesTileMatch(tileName, tiles[# _gx-1, _gy+1]);
        
        // -- Selecting Tile Look --
        
        // Middle Tile
        if (NW && N && NE && W && E && SW && S && SE){
            return;
        }
        
        // Top Left Tile
        else if (!N && !W && E && S){
             tilemap_set(_tilemap_id, baseLook - tileSetWidth - 1, _gx, _gy);
        }
        
        // Top Tile
        else if (!N && W && E && S){
             tilemap_set(_tilemap_id, baseLook - tileSetWidth, _gx, _gy);
        }
        
        // Top Right Tile
        else if (!N && W && !E && S){
             tilemap_set(_tilemap_id, baseLook - tileSetWidth + 1, _gx, _gy);
        }
        
        // Left Tile
        else if (N && !W && E && S){
             tilemap_set(_tilemap_id, baseLook - 1, _gx, _gy);
        }
        
        // Right Tile
        else if (N && W && !E && S){
             tilemap_set(_tilemap_id, baseLook + 1, _gx, _gy);
        }
        
        // Bottom Left Tile
        else if (N && !W && E && !S){
             tilemap_set(_tilemap_id, baseLook + tileSetWidth - 1, _gx, _gy);
        }
        
        // Bottom Tile
        else if (N && W && E && !S){
             tilemap_set(_tilemap_id, baseLook + tileSetWidth, _gx, _gy);
        }
        
        // Bottom Right Tile
        else if (N && W && !E && !S){
             tilemap_set(_tilemap_id, baseLook + tileSetWidth + 1, _gx, _gy);
        }
        
        // Top I Tile
        else if (!N && !W && !E && S){
             tilemap_set(_tilemap_id, baseLook - tileSetWidth + 2, _gx, _gy);
        }
        
        // Middle I Tile
        else if (N && !W && !E && S){
             tilemap_set(_tilemap_id, baseLook + 2, _gx, _gy);
        }
        
        // Bottom I Tile
        else if (N && !W && !E && !S){
             tilemap_set(_tilemap_id, baseLook + tileSetWidth + 2, _gx, _gy);
        }
        
        // Left "-" Tile
        else if (!N && !W && E && !S){
             tilemap_set(_tilemap_id, baseLook - tileSetWidth + 3, _gx, _gy);
        }
        
        // Middle "-" Tile
        else if (!N && W && E && !S){
             tilemap_set(_tilemap_id, baseLook - tileSetWidth + 4, _gx, _gy);
        }
        
        // Right "-" Tile
        else if (!N && W && !E && !S){
             tilemap_set(_tilemap_id, baseLook - tileSetWidth + 5, _gx, _gy);
        }
        
        // Lone Tile
        else if (!N && !W && !E && !S){
            tilemap_set(_tilemap_id, baseLook + 3, _gx, _gy);
        }
        
        // Top Left Corner Tile
        else if (N && W && E && S && !SE){
             tilemap_set(_tilemap_id, baseLook + 4, _gx, _gy);
        }
        
        // Top Right Corner Tile
        else if (N && W && E && S && !SW){
             tilemap_set(_tilemap_id, baseLook + 5, _gx, _gy);
        }
        
        // Top Left + Right Corner Tile
        else if (N && W && E && S && !SE && !SW){
             tilemap_set(_tilemap_id, baseLook + 6, _gx, _gy);
        }
        
        // Top Left + Right Corner + Top Tile
        else if (!N && W && E && S && !SE && !SW){
             tilemap_set(_tilemap_id, baseLook + 7, _gx, _gy);
        }
        
        // Bottom Left Corner Tile
        else if (N && W && E && S && !NE){
             tilemap_set(_tilemap_id, baseLook + tileSetWidth + 4, _gx, _gy);
        }
        
        // Bottom Right Corner Tile
        else if (N && W && E && S && !NW){
             tilemap_set(_tilemap_id, baseLook + tileSetWidth + 5, _gx, _gy);
        }
        
        // Bottom Left + Right Corner Tile
        else if (N && W && E && S && !NE && !NW){
             tilemap_set(_tilemap_id, baseLook + tileSetWidth + 6, _gx, _gy);
        }
        
        // Bottom Left Corner + Bottom Tile
        else if (N && W && E && !S && !NE){
             tilemap_set(_tilemap_id, baseLook + tileSetWidth*2 + 4, _gx, _gy);
        }
        
        // Bottom Right Corner + Bottom Tile
        else if (N && W && E && !S && !NW){
             tilemap_set(_tilemap_id, baseLook + tileSetWidth*2 + 5, _gx, _gy);
        }
        
        // Bottom Left + Right Corner + Bottom Tile
        else if (N && W && E && !S && !NE && !NW){
             tilemap_set(_tilemap_id, baseLook + tileSetWidth*2 + 6, _gx, _gy);
        }
        
        // Bottom Left Corner + Top Right Corner Tile
        else if (N && W && E && S && !NE && !SW){
             tilemap_set(_tilemap_id, baseLook - tileSetWidth + 6, _gx, _gy);
        }
        
        // Bottom Right Corner + Top Left Corner Tile
        else if (N && W && E && S && !NW && !SE){
             tilemap_set(_tilemap_id, baseLook - tileSetWidth + 7, _gx, _gy);
        }
    }
}