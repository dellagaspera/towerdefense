boolean clickingOnPath = false;
void mouseReleased() {
    clickingOnPath = false;
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