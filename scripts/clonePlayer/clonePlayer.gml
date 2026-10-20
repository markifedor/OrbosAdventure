function clonePlayer(player) {
    with (player) {
        // 1. Instantiate the new player instance
      var _clone = instance_create_layer(x, y, layer, object_index);
      
      // 2. Get all variable names declared on this instance
      var _vars = variable_instance_get_names(id);
      var _count = array_length(_vars);
      
      // 3. Dynamically copy all variables from source to clone
      for (var i = 0; i < _count; i++) {
          var _var_name = _vars[i];
          var _val = variable_instance_get(id, _var_name);
          
          // Deep copy arrays so memory references aren't shared
          if (is_array(_val)) { 
            variable_instance_set(_clone, _var_name, variable_clone(_val));
          } 
          // Skip copying the source queue ID directly
          else if (_var_name != "moveBuffer") {
              variable_instance_set(_clone, _var_name, _val);
          }
      }
      
      // 4. Handle unique data structures explicitly (deep copy the queue)
      ds_queue_copy(_clone.moveBuffer, moveBuffer);
      
      // 5. Reset surface pointer so the clone creates its own VRAM surface
      _clone.slime_surf = -1;
      
      return _clone;
    }
}