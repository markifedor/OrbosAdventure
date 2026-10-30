function drawSlimeMeter(player, has_other_meter, is_left){
    c_high_level = #228976;
    c_medium_high_level = #ADB70B;
    c_medium_level = #AF7C16;
    c_low_level = #B23817;
    
    var x_pos = view_wport/2;
    var sprite = spr_slime_meter;
    if (has_other_meter){
        if (is_left){
            x_pos -= 50;
            sprite = spr_slime_meter_left;
        } else {
            x_pos += 50;
            sprite = spr_slime_meter_right;
        }
    }
    
    draw_sprite(sprite, 0, x_pos, 70);
    draw_set_font(SlimeNumberFont);
    if (player.steps <= 1){
        draw_set_color(c_low_level);
    } else if (player.steps == 2){
        draw_set_color(c_medium_level);
    } else if (player.steps == 3){
        draw_set_color(c_medium_high_level);
    } else{
        draw_set_colour(c_high_level);   
    }
    draw_text(x_pos, 70, $"{instance_exists(player) ? player.steps : 0}")
    draw_set_colour(c_white);
    draw_set_font(DebugFont);
}