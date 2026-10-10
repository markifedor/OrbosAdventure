function chooseTileLook(controller, _gx, _gy){
    with(controller){
        if (is_undefined(tiles[# _gx, _gy])){
            return;
        }
         
        var baseLook = tiles[# _gx, _gy][$ "look"];
        var tileName = tiles[# _gx, _gy][$ "name"];
        
        if (tileName != "wall"){
            return;
        }
        
        // Check tile type of surrounding tiles
        var _tl = true;
        var _tp = true;
        var _tr = true;
        var _lf = true;
        var _rt = true;
        var _bl = true;
        var _bm = true;
        var _br = true;
        
        // Checking Top Left Tile
        var checkingTile = tiles[# _gx-1, _gy-1];
        if (!is_undefined(checkingTile)){
            _tl = tileName == checkingTile[$ "name"];
        }
        
        // Checking Top Tile
        checkingTile = tiles[# _gx, _gy-1];
        if (!is_undefined(checkingTile)){
            _tp = tileName == checkingTile[$ "name"];
        }
        
        // Checking Top Right Tile
        checkingTile = tiles[# _gx+1, _gy-1];
        if (!is_undefined(checkingTile)){
            _tr = tileName == checkingTile[$ "name"];
        }
        
        // Checking Left Tile
        checkingTile = tiles[# _gx-1, _gy];
        if (!is_undefined(checkingTile)){
            _lf = tileName == checkingTile[$ "name"];
        }
        
        // Checking Right Tile
        checkingTile = tiles[# _gx+1, _gy];
        if (!is_undefined(checkingTile)){
            _rt = tileName == checkingTile[$ "name"];
        }
        
        // Checking Bottom Left Tile
        checkingTile = tiles[# _gx-1, _gy+1];
        if (!is_undefined(checkingTile)){
            _bl = tileName == checkingTile[$ "name"];
        }
        
        // Checking Bottom Tile
        checkingTile = tiles[# _gx, _gy+1];
        if (!is_undefined(checkingTile)){
            _bm = tileName == checkingTile[$ "name"];
        }
        
        // Checking Bottom Right Tile
        checkingTile = tiles[# _gx+1, _gy+1];
        if (!is_undefined(checkingTile)){
            _br = tileName == checkingTile[$ "name"];
        }
        
        // Selecting Tile Look
        // Middle Tile
        if (_tl && _tp && _tr && _lf && _rt && _bl && _bm && _br){
            return;
        }
        
        // Top Left Tile
        if (!_tp && !_lf && _rt && _bm){
             tilemap_set(_tilemap_id, baseLook - 32 - 1, _gx, _gy);
        }
        
        // Top Tile
        if (!_tp && _lf && _rt && _bm){
             tilemap_set(_tilemap_id, baseLook - 32, _gx, _gy);
        }
        
        // Top Right Tile
        if (!_tp && _lf && !_rt && _bm){
             tilemap_set(_tilemap_id, baseLook - 32 + 1, _gx, _gy);
        }
        
        // Left Tile
        if (_tp && !_lf && _rt && _bm){
             tilemap_set(_tilemap_id, baseLook - 1, _gx, _gy);
        }
        
        // Right Tile
        if (_tp && _lf && !_rt && _bm){
             tilemap_set(_tilemap_id, baseLook + 1, _gx, _gy);
        }
        
        // Bottom Left Tile
        if (_tp && !_lf && _rt && !_bm){
             tilemap_set(_tilemap_id, baseLook + 32 - 1, _gx, _gy);
        }
        
        // Bottom Tile
        if (_tp && _lf && _rt && !_bm){
             tilemap_set(_tilemap_id, baseLook + 32, _gx, _gy);
        }
        
        // Bottom Right Tile
        if (_tp && _lf && !_rt && !_bm){
             tilemap_set(_tilemap_id, baseLook + 32 + 1, _gx, _gy);
        }
        
        // Top I Tile
        if (!_tp && !_lf && !_rt && _bm){
             tilemap_set(_tilemap_id, baseLook - 32 + 2, _gx, _gy);
        }
        
        // Middle I Tile
        if (_tp && !_lf && !_rt && _bm){
             tilemap_set(_tilemap_id, baseLook + 2, _gx, _gy);
        }
        
        // Bottom I Tile
        if (_tp && !_lf && !_rt && !_bm){
             tilemap_set(_tilemap_id, baseLook + 32 + 2, _gx, _gy);
        }
        
        // Left "-" Tile
        if (!_tp && !_lf && _rt && !_bm){
             tilemap_set(_tilemap_id, baseLook - 32 + 3, _gx, _gy);
        }
        
        // Middle "-" Tile
        if (!_tp && _lf && _rt && !_bm){
             tilemap_set(_tilemap_id, baseLook - 32 + 4, _gx, _gy);
        }
        
        // Right "-" Tile
        if (!_tp && _lf && !_rt && !_bm){
             tilemap_set(_tilemap_id, baseLook - 32 + 5, _gx, _gy);
        }
        
        // Lone Tile
        if (!_tp && !_lf && !_rt && !_bm){
            tilemap_set(_tilemap_id, baseLook + 3, _gx, _gy);
        }
        
        // Top Left Corner Tile
        if (_tp && _lf && _rt && _bm && !_br){
             tilemap_set(_tilemap_id, baseLook + 4, _gx, _gy);
        }
        
        // Top Right Corner Tile
        if (_tp && _lf && _rt && _bm && !_bl){
             tilemap_set(_tilemap_id, baseLook + 5, _gx, _gy);
        }
        
        // Top Left + Right Corner Tile
        if (_tp && _lf && _rt && _bm && !_br && !_bl){
             tilemap_set(_tilemap_id, baseLook + 6, _gx, _gy);
        }
        
        // Top Left + Right Corner + Top Tile
        if (!_tp && _lf && _rt && _bm && !_br && !_bl){
             tilemap_set(_tilemap_id, baseLook + 7, _gx, _gy);
        }
        
        // Bottom Left Corner Tile
        if (_tp && _lf && _rt && _bm && !_tr){
             tilemap_set(_tilemap_id, baseLook + 32 + 4, _gx, _gy);
        }
        
        // Bottom Right Corner Tile
        if (_tp && _lf && _rt && _bm && !_tl){
             tilemap_set(_tilemap_id, baseLook + 32 + 5, _gx, _gy);
        }
        
        // Bottom Left + Right Corner Tile
        if (_tp && _lf && _rt && _bm && !_tr && !_tl){
             tilemap_set(_tilemap_id, baseLook + 32 + 6, _gx, _gy);
        }
        
        // Bottom Left Corner + Bottom Tile
        if (_tp && _lf && _rt && !_bm && !_tr){
             tilemap_set(_tilemap_id, baseLook + 32*2 + 4, _gx, _gy);
        }
        
        // Bottom Right Corner + Bottom Tile
        if (_tp && _lf && _rt && !_bm && !_tl){
             tilemap_set(_tilemap_id, baseLook + 32*2 + 5, _gx, _gy);
        }
        
        // Bottom Left + Right Corner + Bottom Tile
        if (_tp && _lf && _rt && !_bm && !_tr && !_tl){
             tilemap_set(_tilemap_id, baseLook + 32*2 + 6, _gx, _gy);
        }
        
        // Bottom Left Corner + Top Right Corner Tile
        if (_tp && _lf && _rt && _bm && !_tr && !_bl){
             tilemap_set(_tilemap_id, baseLook - 32 + 6, _gx, _gy);
        }
        
        // Bottom Right Corner + Top Left Corner Tile
        if (_tp && _lf && _rt && _bm && !_tl && !_br){
             tilemap_set(_tilemap_id, baseLook - 32 + 7, _gx, _gy);
        }
    }
}