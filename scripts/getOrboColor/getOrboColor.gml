function getOrboColors(player, h = 0, s = 0, v = 0){
    with(player){
        var hueShift = h;
        if (other_player.in_use) {
            if (id == controller.player) {
                hueShift -= 10;
            }
            if (id == controller.copyPlayer) {
                hueShift += 10;
            }
        }
        if (is_fiery){
            hueShift -= 95 + 6*sin(squish_counter*3/2*pi/game_get_speed(gamespeed_fps));
        }
        var draw_outline_color = color_shift_hsv(outline_color, hueShift, s, v);
        var draw_main_color    = color_shift_hsv(main_color, hueShift, s, v);
        var draw_outer_color   = color_shift_hsv(outer_color, hueShift, s, v);
        
        return [draw_outline_color, draw_main_color, draw_outer_color];
    }
    return []
}