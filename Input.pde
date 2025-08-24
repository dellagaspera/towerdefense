boolean mouseOnPath = false;
void mouseReleased() {
    if(mouseButton != LEFT) return;
    boolean clickedUi = false;
    for(UIObject o : uiObjects) {
        if(o.hover && o.isActive && o.isClickable) {
            o.onClick();
            clickedUi = true;
        }
    }
    if(clickedUi) return;

    if(buildMode) if(build()) return;

    Structure s = structuresGrid.get(worldToGridPosition(new PVector(mouseX, mouseY)));
    if(s != null) {
        if(s.isTower()) {
            uiObjects.remove((UIObject)inspectMenu);
            new InspectMenu((Tower)s);
            return;
        }
    }
            
    uiObjects.remove((UIObject)inspectMenu);
    clearInspectMenu();
    inspectMenu = null;
}