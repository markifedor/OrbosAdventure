// 1. Free surface from VRAM
if (surface_exists(slime_surf)) {
    surface_free(slime_surf);
}

// 2. Destroy movement queue from RAM
if (ds_exists(moveBuffer, ds_type_queue)) {
    ds_queue_destroy(moveBuffer);
}