function placeTile(controller, _csv_grid, _gx, _gy){
    var _tile_csv = string_trim(_csv_grid[# _gx, _gy]);
    if (_tile_csv == ""){
        controller.tiles[# _gx, _gy] = undefined;
        return;
    }
    
    var _tile_struct = controller._csv_to_tile_struct[$ string_char_at(_tile_csv, 1)];
    if (is_undefined(_tile_struct)){
        show_error("Undefined tile CSV id at (" + chr(ord("A")+_gx) + ", " + string(1+_gy) + ") of " + room_get_name(room) + ": \"" + _csv_grid[# _gx, _gy] + "\"", true);
    }
    if (string_length(string_letters(_tile_csv)) >= 2){
        var _overlay_struct = controller._csv_to_tile_struct[$ string_char_at(string_letters(_tile_csv), 2)]
        if (!(is_undefined(_overlay_struct))){
            if (_overlay_struct[$ "properties"][$ "overlay"]){
                controller.overlayTiles[# _gx, _gy] = _overlay_struct;
                tilemap_set(controller._overlay_tilemap_id, _overlay_struct[$ "look"], _gx, _gy);   
            }
            else {
                show_error("Non-Overlay Tile placed in overlay slot at (" + chr(ord("A")+_gx) + ", " + string(1+_gy) + ") of " + room_get_name(room) + ": \"" + _csv_grid[# _gx, _gy] + "\"", true);
            }
        }
        
    }
    
    if (!is_undefined(_tile_struct[$ "properties"])){
        var props =  _tile_struct[$ "properties"];
        if (!is_undefined(props[$ "start"]) and props[$ "start"]){
            player = instance_create_layer(_gx*TILE_HEIGHT+TILE_HEIGHT*.5, _gy*TILE_HEIGHT+TILE_HEIGHT*.5, "Instances", Obj_Player);
            player.pos = [_gx, _gy];
            player.steps = real(string_digits(_tile_csv));
            player._room_height = maxRoomHeight;
            player._room_width = maxRoomWidth;
            player.controller = controller;
        }
        if (!is_undefined(props[$ "convertOnStepCount"])){
            var stepCount = real(string_digits(_tile_csv));
            
            controller.overlayTiles[# _gx, _gy] = int64(stepCount);
            
            _tile_struct = variable_clone(_tile_struct);
            _tile_struct[$ "properties"][$ "stepCount"] = stepCount;
            
            tilemap_set(controller._overlay_tilemap_id, getTileIdOfDigit(stepCount), _gx, _gy);
            
            ds_list_add(controller.selfUpdatingTilesCoords, [_gx, _gy]);
        }
        
        if(!is_undefined(props[$ "roomLabel"])){
            controller.roomLabelTileCoords = [_gx, _gy];
            tilemap_set(controller._tilemap_id, _tile_struct[$ "look"], _gx, _gy);
        }
        else if (_tile_struct[$ "look"] != 1){
            // Add background tile to each occupied tile that's not already the background tile
            tilemap_set(controller._background_tilemap_id, 1, _gx, _gy);
        }
    }
    
    controller.tiles[# _gx, _gy] = _tile_struct;
    tilemap_set(controller._tilemap_id, _tile_struct[$ "look"], _gx, _gy);
}