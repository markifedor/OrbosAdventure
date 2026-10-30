function handleSelfUpdatingTiles(controller){
    with(controller){
        for (var i = 0; i < ds_list_size(selfUpdatingTilesCoords); i++){
            var _gx = selfUpdatingTilesCoords[| i][0];
            var _gy = selfUpdatingTilesCoords[| i][1];
            var selfUpdatingTile = tiles[# _gx, _gy];
            var props = selfUpdatingTile[$ "properties"];
            
            var playerExists = player.in_use;
            var copyPlayerExists = copyPlayer.in_use;
            
            if (is_undefined(props)){
                continue;
            }
            
            // Step Conversions
            var stepCount = props[$ "stepCount"];
            if (!is_undefined(stepCount)){
                var playerStepsMatch = player.steps == stepCount;
                var copyPlayerStepsMatch = controller.copyPlayer.steps == stepCount;
                
                var shouldConvert = (playerExists and playerStepsMatch) or (copyPlayerExists and copyPlayerStepsMatch);
                var convertTo = undefined;
                if (!is_undefined(props[$ "convertOnStepCount"])){
                    convertTo = props[$ "convertOnStepCount"];
                }
                else if (!is_undefined(props[$ "convertOnNotStepCount"])) {
                    shouldConvert = !shouldConvert;
                    convertTo = props[$ "convertOnNotStepCount"];
                    
                    if (shouldConvert and playerExists and array_equals(player.pos, [_gx, _gy])){
                        player.targetTilePos = player.pos_before_move;
                        move_to_tile(controller, player);
                    } else if (shouldConvert and copyPlayerExists and array_equals(copyPlayer.pos, [_gx, _gy])){
                        copyPlayer.targetTilePos = copyPlayer.pos_before_move;
                        move_to_tile(controller, copyPlayer);
                    }
                }
                
                if (shouldConvert){
                    tiles[# _gx, _gy] = variable_clone(controller._csv_to_tile_struct[$ convertTo]);
                    tiles[# _gx, _gy][$ "properties"][$ "stepCount"] = stepCount;
                    
                    var convertedTile = tiles[# _gx, _gy];
                    var convertedProps = convertedTile[$ "properties"];
                    
                    if (convertedProps[$ "stepCountVisible"]){
                        tilemap_set(_overlay_tilemap_id, getTileIdOfDigit(convertedProps[$ "stepCount"]), _gx, _gy);  
                    } else {
                        tilemap_set(_overlay_tilemap_id, 0, _gx, _gy);
                    }
                    tilemap_set(_tilemap_id, convertedTile[$ "look"], _gx, _gy);
                }    
            }
        }
    }
}