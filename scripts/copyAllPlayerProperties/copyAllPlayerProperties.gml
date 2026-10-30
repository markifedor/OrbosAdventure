function copyAllPlayerProperties(player, otherPlayer) {
    with (player) {
        // 2. Get all variable names declared on this instance
        var _vars = variable_instance_get_names(id);
        var _count = array_length(_vars);
         
        // 3. Dynamically copy all variables from source to clone
        for (var i = 0; i < _count; i++) {
            var _var_name = _vars[i];
            var _val = variable_instance_get(id, _var_name);
            
            // Deep copy arrays so memory references aren't shared
            if (is_array(_val)) { 
              variable_instance_set(otherPlayer, _var_name, variable_clone(_val));
            } 
            // Skip copying the source queue ID directly
            else if (_var_name != "moveBuffer") {
                variable_instance_set(otherPlayer, _var_name, _val);
            }
        }
         
        // 4. Handle unique data structures explicitly (deep copy the queue)
        ds_queue_copy(otherPlayer.moveBuffer, moveBuffer);
        otherPlayer.other_player = player;
    }
}