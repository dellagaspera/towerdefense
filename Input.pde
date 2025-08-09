void mouseReleased() {
    boolean clickedUi = false;
    for(UIObject o : uiObjects) {
        if(o.hover && o.isActive) {
            o.onClick();
            clickedUi = true;
        }
    }
    if(clickedUi) return;

    if(buildMode) build();
}