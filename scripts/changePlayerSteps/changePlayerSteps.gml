function changePlayerSteps(player, controller, newSteps){
    player.steps = newSteps;
    player.radius = floor(3+2.25*power(player.steps-1, 2/3));
    //if (player.radius mod 2 == 0) { player.radius += 1; }
}