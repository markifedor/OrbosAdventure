function getCorrectPlayerCoors(controller, pos, radius, reposition_x = true){
    var correctCoors = [pos[0], 0];
    if (reposition_x){ 
        correctCoors[0] = pos[0] * controller.TILE_HEIGHT + controller.TILE_HEIGHT * .5;
    }
    correctCoors[1] = pos[1] * controller.TILE_HEIGHT + 2/3*controller.TILE_HEIGHT;
    return correctCoors;
}