function handleSelfUpdatingTiles(controller, player){
    with(controller){
        for (var i = 0; i < ds_list_size(selfUpdatingTiles); i++){
            var _gx = selfUpdatingTiles[| i][0];
            var _gy = selfUpdatingTiles[| i][1];
            var selfUpdatingTile = tiles[# _gx, _gy];
            var props = selfUpdatingTile[$ "properties"];
            
            if (is_undefined(props)){
                continue
            }
            
            // Step Conversions
            var shouldConvert = false;
            var convertTo = undefined;
            
            if (!is_undefined(props[$ "convertOnStepCount"])){
                shouldConvert = (player.steps == overlayTiles[# _gx, _gy]);
                convertTo = props[$ "convertOnStepCount"];
            }
            else if (!is_undefined(props[$ "convertOnNotStepCount"])) {
                shouldConvert = (player.steps != overlayTiles[# _gx, _gy]);
                convertTo = props[$ "convertOnNotStepCount"];
            }
            
            if (shouldConvert){
                var stepCount = props[$ "stepCount"];
                tiles[# _gx, _gy] = variable_clone(controller._csv_to_tile_struct[$ convertTo]);
                tiles[# _gx, _gy][$ "properties"][$ "stepCount"] = stepCount;
                
                var convertedTile = tiles[# _gx, _gy];
                var convertedProps = convertedTile[$ "properties"];
                
                if (convertedProps[$ "stepCountVisible"]){
                    tilemap_set(_overlay_tilemap_id, convertedTile[$ "look"] + 1 + convertedProps[$ "stepCount"], _gx, _gy);  
                } else {
                    tilemap_set(_overlay_tilemap_id, 0, _gx, _gy);
                }
                tilemap_set(_tilemap_id, convertedTile[$ "look"], _gx, _gy);
            }
            
        }
    }
}