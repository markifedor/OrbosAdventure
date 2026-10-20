gpu_set_texfilter(false);
draw_set_font(DebugFont);
draw_set_halign(fa_center);

c_slime = #19665A;

// Public Variables
maxRoomWidth = 16;
maxRoomHeight = 16;
tiles = ds_grid_create(maxRoomWidth, maxRoomHeight);
ds_grid_clear(tiles, undefined);

overlayTiles = ds_grid_create(maxRoomWidth, maxRoomHeight);
_csv_to_tile_struct = undefined;

var _tile_layer_id = layer_get_id("Tiles");
_tilemap_id = layer_tilemap_get_id(_tile_layer_id);
tileset_id = tilemap_get_tileset(_tilemap_id);
tileset_name = tileset_get_name(tileset_id);
tileset_sprite = asset_get_index("spr_" + $"{tileset_name}");

var _overlayTiles_layer_id = layer_get_id("OverlayTiles");
_overlay_tilemap_id = layer_tilemap_get_id(_overlayTiles_layer_id);

var _backgroundTiles_layer_id = layer_get_id("BackgroundTiles");
_background_tilemap_id = layer_tilemap_get_id(_backgroundTiles_layer_id);

var _borderTiles_layer_id = layer_get_id("BorderTiles");
_border_tilemap_id = layer_tilemap_get_id(_borderTiles_layer_id);

TILE_HEIGHT = tilemap_get_tile_height(_tilemap_id);

player = noone;
copyPlayer = noone;
roomFinished = false;
roomFailed = false;

selfUpdatingTilesCoords = ds_list_create();

roomLabelTileCoords = undefined;
if (room != DefaultRoom){
    roomNum = string_digits(room_get_name(room));
    roomNumOnes = roomNum mod 10;
    roomNumTens = roomNum div 10;
}
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
        readInCSVTile(id, _csv_grid, _gx, _gy);
    }
}

delete _csv_grid

for (var _gx = 0; _gx < _width; _gx++){
    for (var _gy = 0; _gy < _height; _gy++){
        pretifyTile(id, _gx, _gy);
    }
}    

player.ready = true