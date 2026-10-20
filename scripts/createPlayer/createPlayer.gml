function createPlayer(controller, pos, steps){
    var player = instance_create_layer(-1, -1, "Instances", Obj_Player);
    player.controller = controller;
    player.pos = pos;
    changePlayerSteps(player, id, steps);
    var coors = getCorrectPlayerCoors(controller, player.pos, player.radius);
    player.x = coors[0];
    player.y = coors[1];
    player._draw_y = player.y;
    return player;
}