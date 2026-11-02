function getTileProperty(property, tile, hasOverlay, overlayTile=undefined, doAdd=false){
    var result = 0;
    if (hasOverlay and !is_undefined(overlayTile)){
        var overlayPropertyValue = overlayTile[$ "properties"][$ property];
        if (!is_undefined(overlayPropertyValue)){
            if (doAdd){
                try{
                    result += overlayPropertyValue;
                }
                catch (e){
                    show_error(e, true);
                }
            } else {
                return overlayPropertyValue;
            }
        }
    }
    
    var propertyValue = tile[$ "properties"][$ property];
    if (!is_undefined(propertyValue)) {
        if (doAdd) { 
            try{
                return result + propertyValue;
            }
            catch (e){
                show_error(e, true);
            }   
        }
        return tile[$ "properties"][$ property];
    }
    
}