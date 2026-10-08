if (room == DefaultRoom){
    displayTextWithOverlay("You beat all the levels in this beta! Thanks for playing!")
    return
}

draw_text(view_wport/2, 80, $"Steps Remaining: {instance_exists(player) ? player.steps : 0}")

if (room == Room1) {
    draw_text(view_wport/2, 120, "Move with the W, A, S, D keys")
}

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

if (roomFailed) {
    displayTextWithOverlay("Failure. Press R to restart.")
}
if (roomFinished) {
    displayTextWithOverlay("Success! Press F to continue.")
}