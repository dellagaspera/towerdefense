ArrayList<UIObject> uiObjects = new ArrayList<>();

class UIObject {
    boolean active = true;
    PVector pos = new PVector();
    PVector size = new PVector();

    void init() {

    }

    void render() {

    }

    void update() {
        render();
    }

    void activate() {
        active = true;
    }

    void deactivate() {
        active = false;
    }

    UIObject(PVector pos, PVector size) {
        this.pos = pos;
        this.size = size;

        uiObjects.add(this);
    }
}