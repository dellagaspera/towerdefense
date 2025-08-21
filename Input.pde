boolean mouseOnPath = false;
void mouseReleased() {
    mouseOnPath = Map.getNodeFrom(worldToGridPosition(new PVector(mouseX, mouseY))) != null;
    boolean clickedUi = false;
    for(UIObject o : uiObjects) {
        if(o.hover && o.isActive && o.isClickable) {
            o.onClick();
            clickedUi = true;
        }
    }
    if(clickedUi) return;

    if(buildMode) build();
}