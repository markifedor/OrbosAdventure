function displayTextWithOverlay(displayText){
    var dim_overlay_color = c_black;
    var dim_overlay_alpha = 0.7;
        
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    // Set drawing blend properties
    draw_set_color(dim_overlay_color);
    draw_set_alpha(dim_overlay_alpha);
    
    // Draw semi-transparent rectangle over the entire screen
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    // Reset draw properties back to defaults!
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    
    draw_text(view_wport/2, view_hport/2, displayText)
}