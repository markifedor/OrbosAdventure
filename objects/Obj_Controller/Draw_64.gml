if (room_jump_debug_on) {
    // Only keep numeric digits typed by the user
    room_jump_input_buffer = string_digits(keyboard_string)
    var preview_text = room_jump_input_buffer
    if (preview_text = ""){ // Hate that but '=' not '=='
        preview_text = "_"
    }
    
    draw_set_halign(fa_left);
    draw_text(5, view_hport-100, preview_text);
    draw_set_halign(fa_center);
    
    // Press Enter to submit
    if (keyboard_check_pressed(vk_enter) or alarm_get(0) <= 0) {
        if (room_jump_input_buffer != "") {
            var _room_num = real(room_jump_input_buffer)
            var _target_room = asset_get_index("Room" + string(_room_num))
            
            if (room_exists(_target_room)) {
                room_goto(_target_room)
            }
            
            keyboard_string = ""
            alarm_set(0, game_get_speed(gamespeed_fps)*1)
        }
    }
    
    // Cancel with Escape
    if (keyboard_check_pressed(vk_escape)) {
        room_jump_debug_on = false
    }
}

if (room == DefaultRoom){
    displayTextWithOverlay("You beat all the levels in this beta! Thanks for playing! \n\n Press R to go to level 1. \n\n Press B and input a room number to go to any level")
    return
}

if (instance_exists(player)){
    draw_sprite(spr_slime_meter, 0, view_wport/2, 80);
    draw_set_font(SlimeNumberFont);
    if (player.steps <= 1){
        draw_set_color(c_red);
    } else if (player.steps == 2){
        draw_set_color(c_orange);
    } else if (player.steps == 3){
        draw_set_color(c_yellow);
    } else{
        draw_set_colour(c_slime);   
    }
    draw_text(view_wport/2, 80, $"{instance_exists(player) ? player.steps : 0}")
    draw_set_colour(c_white);
    draw_set_font(DebugFont);
}


if (room == Room1) {
    draw_text(view_wport/2, 200, "Move with the W, A, S, D keys")
}
if (room == Room5) {
    draw_text(view_wport/2, 200, "Press R to restart the level at any time.")
}

if (roomFailed) {
    displayTextWithOverlay("Failure. Press R to restart.")
}
if (roomFinished) {
    displayTextWithOverlay("Success! Press F to continue.")
}

if (roomNum < 10){
    tilemap_set(_overlay_tilemap_id, getTileIdOfDigit(roomNumOnes), roomLabelTileCoords[0], roomLabelTileCoords[1]);
}
else { 
    draw_sprite_part_ext(
        tileset_sprite, 0, 
        roomNumTens*TILE_HEIGHT, TILE_HEIGHT, TILE_HEIGHT, TILE_HEIGHT, 
        roomLabelTileCoords[0]*TILE_HEIGHT + (TILE_HEIGHT * 1 / 2), roomLabelTileCoords[1]*TILE_HEIGHT + TILE_HEIGHT,
        2, 2, c_white, 1
    );
    draw_sprite_part_ext(
        tileset_sprite, 0, 
        roomNumOnes*TILE_HEIGHT, TILE_HEIGHT, TILE_HEIGHT, TILE_HEIGHT, 
        roomLabelTileCoords[0]*TILE_HEIGHT + (TILE_HEIGHT * 3 / 2), roomLabelTileCoords[1]*TILE_HEIGHT + TILE_HEIGHT,
        2, 2, c_white, 1
    );
}