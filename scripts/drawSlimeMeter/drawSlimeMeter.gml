function drawSlimeMeter(player, has_other_meter, is_left, steps, timer, growing, shrinking){
    var c_high_level = #41a38f;
    var lower_level_offset = 75;
    var hueDir = -1;
    if (player.is_fiery){
        c_high_level = #5a99d8;
        lower_level_offset = 20;
        hueDir = 1;
    }
    var c_medium_high_level = color_shift_hsv(c_high_level, hueDir*lower_level_offset, 0, 0);
    var c_medium_level = color_shift_hsv(c_high_level, hueDir*(lower_level_offset+25), 0, 0);
    var c_low_level = color_shift_hsv(c_high_level, hueDir*(lower_level_offset+50), 0, 0);
    
    var x_pos = view_wport/2;
    
    if (has_other_meter){
        if (is_left){
            x_pos -= 50;
        } else {
            x_pos += 50;
        }
    }
    
    // Draw Background
    var backgroundSize = 65;
    if (growing){
        backgroundSize += timer*3/5;
    }
    if (shrinking) {
        backgroundSize -= timer*3/5;
    }
    
    var orboColors = getOrboColors(player);
    var draw_outline_color = color_shift_hsv(orboColors[0], 0, 0, -30);
    var draw_main_color    = orboColors[1];
    var draw_outer_color   = orboColors[2];
    
    
     
    draw_set_color(draw_outline_color);
    draw_set_circle_precision(40);
    draw_circle(x_pos, 107, backgroundSize, false);
    draw_circle_colour(x_pos, 107, backgroundSize-8, draw_main_color, draw_outer_color, false);
    draw_set_circle_precision(16);
    
    // Draw Number
    
    draw_set_font(SlimeNumberFont);
    if (steps <= 1){
        draw_set_color(c_low_level);
    } else if (steps == 2){
        draw_set_color(c_medium_level);
    } else if (steps == 3){
        draw_set_color(c_medium_high_level);
    } else{
        draw_set_colour(c_high_level);   
    }
    draw_text(x_pos, 70, $"{instance_exists(player) ? steps : 0}")
    draw_set_colour(c_white);
    draw_set_font(DebugFont);
}