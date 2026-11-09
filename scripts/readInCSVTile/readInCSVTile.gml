function readInCSVTile(controller, _tile_csv, _gx, _gy){
    with (controller) {
        if (_tile_csv == ""){
            tiles[# _gx, _gy] = undefined;
            tilemap_set(_tilemap_id, 0, _gx, _gy);
            
            overlayTiles[# _gx, _gy] = undefined;
            tilemap_set(_overlay_tilemap_id, 0, _gx, _gy);
            return;
        }
        
        var _tile_struct = _csv_to_tile_struct[$ string_char_at(_tile_csv, 1)];
        if (typeof(_tile_struct) != "struct"){
            show_error("Undefined tile CSV id at (" + chr(ord("A")+_gx) + ", " + string(1+_gy) + ") of " + room_get_name(room) + ": \"" + _tile_csv + "\"", true);
        }
        
        var _overlay_struct = undefined;
        var overlay_look = 0;
        if (string_length(string_letters(_tile_csv)) >= 2){
            _overlay_struct = _csv_to_tile_struct[$ string_char_at(string_letters(_tile_csv), 2)]
            if (typeof(_overlay_struct) == "struct"){
                if (!_overlay_struct[$ "properties"][$ "overlay"]){
                    show_error("Non-Overlay Tile placed in overlay slot at (" + chr(ord("A")+_gx) + ", " + string(1+_gy) + ") of " + room_get_name(room) + ": \"" + _tile_csv + "\"", true);
                }
                overlay_look = _overlay_struct[$ "look"];
            }
        }
        overlayTiles[# _gx, _gy] = _overlay_struct;
        tilemap_set(_overlay_tilemap_id, overlay_look, _gx, _gy);   
        
        if (!is_undefined(_tile_struct[$ "properties"])){
            var props =  _tile_struct[$ "properties"];
            if (!is_undefined(props[$ "start"]) and props[$ "start"]){
                var steps = real(string_digits(_tile_csv));
                player = createPlayer(id, [_gx, _gy], steps);
                playerStepsMeter = steps;
                copyPlayer = createPlayer(id, [_gx, _gy], steps);
                copyPlayerStepsMeter = steps;
                player.other_player = copyPlayer;
                copyPlayer.other_player = player;
                
                player.in_use = true;
            }
            if (!is_undefined(props[$ "convertOnStepCount"])){
                var stepCount = real(string_digits(_tile_csv));
                
                overlayTiles[# _gx, _gy] = int64(stepCount);
                
                _tile_struct = variable_clone(_tile_struct);
                _tile_struct[$ "properties"][$ "stepCount"] = stepCount;
                
                tilemap_set(_overlay_tilemap_id, getTileIdOfDigit(stepCount, true), _gx, _gy);
                
                ds_list_add(selfUpdatingTilesCoords, [_gx, _gy]);
            }
            
            if(!is_undefined(props[$ "splitsOnIn"])){
                if (string_length(_tile_csv) != 2){
                    show_error("splitsOnIn Tile at (" + chr(ord("A")+_gx) + ", " + string(1+_gy) + ") has invalid number of characters, expected 2 but got" + string(string_length(_tile_csv)), true);
                }
                var directionAllowSplit = string_char_at( _tile_csv, 2);
                if (directionAllowSplit = ""){
                    show_error("splitsOnIn Tile at (" + chr(ord("A")+_gx) + ", " + string(1+_gy) + ") has no directionAllowSplit" + ": \"" + _tile_csv + "\"", true);
                }
                show_debug_message(directionAllowSplit);
                _tile_struct = variable_clone(_tile_struct);
                _tile_struct[$ "properties"][$ "directionAllowSplit"] = directionAllowSplit;
                switch(directionAllowSplit){
                    case "^":
                        _tile_struct[$ "look"] += 0;
                        break;
                    case ">":
                        _tile_struct[$ "look"] += 1;
                        break;
                    case "v":
                        _tile_struct[$ "look"] += 2;
                        break;
                    case "<":
                        _tile_struct[$ "look"] += 3;
                        break;
                }
            }
            
            if(!is_undefined(props[$ "roomLabel"])){
                roomLabelTileCoords = [_gx, _gy];
                tilemap_set(_tilemap_id, _tile_struct[$ "look"], _gx, _gy);
            }
            else if (_tile_struct[$ "look"] != 1){
                // Add background tile to each occupied tile that's not already the background tile
                tilemap_set(_background_tilemap_id, 1, _gx, _gy);
            }
        }
        
        tiles[# _gx, _gy] = _tile_struct;
        tilemap_set(_tilemap_id, _tile_struct[$ "look"], _gx, _gy);
    }
}