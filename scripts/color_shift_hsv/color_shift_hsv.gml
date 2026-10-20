function color_shift_hsv(_color, _h_offset, _s_offset, _v_offset) {
    // 1. Extract base HSV components (each returns 0–255)
    var _h = color_get_hue(_color);
    var _s = color_get_saturation(_color);
    var _v = color_get_value(_color);

    // 2. Apply relative shifts and clamp within valid GameMaker color bounds (0–255)
    // Hue wraps around using modulo (256) so shifting past red wraps back around
    var _new_h = (_h + _h_offset + 256) mod 256;
    var _new_s = clamp(_s + _s_offset, 0, 255);
    var _new_v = clamp(_v + _v_offset, 0, 255);

    // 3. Recombine into a GameMaker color handle
    return make_color_hsv(_new_h, _new_s, _new_v);
}