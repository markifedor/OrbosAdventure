function drawSlimeMeter(player, has_other_meter, is_left, steps, timer, growing, shrinking){
    c_high_level = #25967F;
    c_medium_high_level = #ADB70B;
    c_medium_level = #AF7C16;
    c_low_level = #B23817;
    
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
    var draw_outline_color = color_shift_hsv(orboColors[0], 0, 0, -20);
    var draw_main_color    = orboColors[1];
    var draw_outer_color   = orboColors[2];
    
    
     
    draw_set_color(draw_outline_color);
    draw_set_circle_precision(40);
    draw_circle(x_pos, 107, backgroundSize, false);
    draw_circle_colour(x_pos, 107, backgroundSize-8, draw_main_color, draw_outer_color, false);
    draw_set_circle_precision(16);
    draw_set_color(c_white);
    
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