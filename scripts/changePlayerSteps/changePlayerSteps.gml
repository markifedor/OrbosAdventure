function changePlayerSteps(player, controller, newSteps){
    player.steps = newSteps;
    player.radius = 3+2.25*power(player.steps-1, 2/3);
}