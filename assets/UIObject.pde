static ArrayList<UIObject> uiObjects = new ArrayList<>();
static HashMap<Integer, ArrayList<UIObject>> priorityUiObjects = new HashMap<>();
int maxRenderPriority = 0;
/*
1 = background (path)
2 = default (buildings, towers, etc)
3 = foreground (UI, buttons, etc)
 */

class UIObject {
    int renderPriority = 3;
    boolean isActive = true;
    boolean isClickable = true;
    
    UIObject parent = null;

    PVector center = new PVector(0.5, 0.5);
    PVector anchor = new PVector(0.5, 0.5);
    PVector position = new PVector(0, 0);
    PVector realPosition = new PVector(0, 0);
    PVector size;

    boolean hover = false;

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

        render();
    }

    void update() {

    }

    void onClick() {

    }

    void render() {
        stroke(255, 0, 0);
        fill(0, 0, 0, 0);
        rect(realPosition.x, realPosition.y, size.x, size.y);

        noStroke();
    }

    void setPriority(int priority) {

        if (priorityUiObjects.containsKey(renderPriority)) {
            priorityUiObjects.get(renderPriority).remove(this);
        }

        renderPriority = priority;

        if (!priorityUiObjects.containsKey(priority)) priorityUiObjects.put(priority, new ArrayList<>());

        priorityUiObjects.get(priority).add(this);

        if (priority > maxRenderPriority) {
            maxRenderPriority = priority;
        }
    }

    void removeObject() {
        // obs.: não lança exceção se não estiver nas listas
        uiObjects.remove(this);
        priorityUiObjects.get(renderPriority).remove(this);
    }

    UIObject(PVector position, PVector size) {
        this.position = position;
        this.size = size;

        init();
        setPriority(renderPriority);

        uiObjects.add(this);
    }
    

    UIObject(UIObject parent, PVector size) {
        this.parent = parent;
        this.anchor = anchor;
        this.size = size;

        init();
        setPriority(renderPriority);

        uiObjects.add(this);
    }
}