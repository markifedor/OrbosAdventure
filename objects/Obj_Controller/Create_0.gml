gpu_set_texfilter(false);
draw_set_font(DebugFont);
draw_set_halign(fa_center);

c_slime = #19665A;

// Public Variables
maxRoomWidth = 16;
maxRoomHeight = 16;
tiles = ds_grid_create(maxRoomWidth, maxRoomHeight);
overlayTiles = ds_grid_create(maxRoomWidth, maxRoomHeight);
_csv_to_tile_struct = undefined;

var _tile_layer_id = layer_get_id("Tiles");
_tilemap_id = layer_tilemap_get_id(_tile_layer_id);
tileset_id = tilemap_get_tileset(_tilemap_id);
tileset_name = tileset_get_name(tileset_id);
tileset_sprite = asset_get_index("spr_" + $"{tileset_name}");

var _overlayTiles_layer_id = layer_get_id("OverlayTiles");
_overlay_tilemap_id = layer_tilemap_get_id(_overlayTiles_layer_id);

TILE_HEIGHT = tilemap_get_tile_height(_tilemap_id);

player = noone;
roomFinished = false;
roomFailed = false;

selfUpdatingTilesCoords = ds_list_create();

roomLabelTileCoords = undefined;
roomNum = string_digits(room_get_name(room));
roomNumOnes = roomNum mod 10;
roomNumTens = roomNum div 10;

// Debug
room_jump_debug_on = false;
room_jump_input_buffer = "";


if (room == DefaultRoom){
    return;
}

// CSV code to Tile object Map
var _buffer = buffer_load("csvToTile.json");
var _json_string = buffer_read(_buffer, buffer_string);
buffer_delete(_buffer);

_csv_to_tile_struct = json_parse(_json_string);

// Tile Building

var _csv_grid = load_csv("rooms/Rooms - " + room_get_name(room) + ".csv");

var _width = ds_grid_width(_csv_grid);
var _height = ds_grid_height(_csv_grid);

for (var _gx = 0; _gx < _width; _gx++){
    for (var _gy = 0; _gy < _height; _gy++){
        var _tile_csv = string_trim(_csv_grid[# _gx, _gy]);
        if (_tile_csv == ""){
            continue;
        }
        var _tile_struct = _csv_to_tile_struct[$ string_char_at(_tile_csv, 1)];
        if (is_undefined(_tile_struct)){
            show_error("Undefined tile CSV id at (" + chr(ord("A")+_gx) + ", " + string(1+_gy) + ") of " + room_get_name(room) + ": \"" + _csv_grid[# _gx, _gy] + "\"", true);
        }
        if (string_length(string_letters(_tile_csv)) >= 2){
            var _overlay_struct = _csv_to_tile_struct[$ string_char_at(string_letters(_tile_csv), 2)]
            if (!(is_undefined(_overlay_struct))){
                overlayTiles[# _gx, _gy] = _overlay_struct;
                tilemap_set(_overlay_tilemap_id, _overlay_struct[$ "look"], _gx, _gy);
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
                player.controller = id;
            }
            if (!is_undefined(props[$ "convertOnStepCount"])){
                var stepCount = real(string_digits(_tile_csv));
                
                overlayTiles[# _gx, _gy] = int64(stepCount);
                
                _tile_struct = variable_clone(_tile_struct);
                _tile_struct[$ "properties"][$ "stepCount"] = stepCount;
                
                tilemap_set(_overlay_tilemap_id, getTileIdOfDigit(stepCount), _gx, _gy);
                
                ds_list_add(selfUpdatingTilesCoords, [_gx, _gy]);
            }
            if(!is_undefined(props[$ "roomLabel"])){
                roomLabelTileCoords = [_gx, _gy];
                tilemap_set(_tilemap_id, _tile_struct[$ "look"], _gx, _gy);
            }
        }
        
        tiles[# _gx, _gy] = _tile_struct;
        tilemap_set(_tilemap_id, _tile_struct[$ "look"], _gx, _gy);
    }
}

for (var _gx = 0; _gx < _width; _gx++){
    for (var _gy = 0; _gy < _height; _gy++){
        chooseTileLook(id, _gx, _gy);
    }
}    

delete _csv_grid
player.ready = true