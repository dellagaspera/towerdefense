static ArrayList<UIObject> uiObjects = new ArrayList<>();
static ArrayList<UIObject> uiObjectsToRemove = new ArrayList<>();

class UIObject {
    boolean isActive = true;
    boolean isClickable = true;

    int background = color(0, 0, 0, 0);
    int outline = color(0, 0, 0, 0);
    
    UIObject parent = null;

    PVector center = new PVector(0.5, 0.5);
    PVector anchor = new PVector(0.5, 0.5);
    PVector position = new PVector(0, 0);
    PVector realPosition = new PVector(0, 0);
    PVector size;

    boolean hover = false;
    boolean canBeDragged;
    boolean dragging = false;

    void init() {

    }

    void _update() {
        update();
        if(!isActive) return;

        if(parent == null) {
            realPosition.set(position);
        } else {
            realPosition.set(parent.realPosition.x + parent.size.x * anchor.x - size.x * center.x + position.x, parent.realPosition.y + parent.size.y * anchor.y - size.y * center.y + position.y);
        }
        
        hover = mouseX >= realPosition.x && mouseX < realPosition.x + size.x && mouseY >= realPosition.y && mouseY < realPosition.y + size.y;

        /*
        if(alpha(background) != 0) {
            fill(background);
        }

        if(alpha(outline) != 0) {
            stroke(outline);
        }

        rect(realPosition.x, realPosition.y, size.x, size.y);
        
        noFill();
        noStroke();
        */

        if(dragging) {
            position.add(mouseX - pmouseX, mouseY - pmouseY);
        }

        render();
    }

    void update() {

    }

    void _onClick() {
        if(canBeDragged) dragging = true;
        onClick();
    }

    void _onRelease() {
        if(canBeDragged) dragging = false;
        onRelease();
    }

    void onClick() {
        
    }

    void onRelease() {

    }

    void render() {
        stroke(255, 0, 0);
        fill(0, 0, 0, 0);
        rect(realPosition.x, realPosition.y, size.x, size.y);

        noStroke();
    }

    void removeObject() {
        // obs.: não lança exceção se não estiver nas listas
        uiObjectsToRemove.add(this);
    }

    UIObject(PVector position, PVector size) {
        this.position = position;
        this.size = size;

        uiObjects.add(this);
        init();
    }
    

    UIObject(UIObject parent, PVector size) {
        this.parent = parent;
        this.anchor = anchor;
        this.size = size;

        uiObjects.add(this);
        init();
    }
}