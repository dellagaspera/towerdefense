class Button extends Image {
    Text buttonText = null;

    void onClick() {

    }

    void update() {
        if(!active) return;
        render();

        if(active && mousePressed && mouseX >= pos.x && mouseX < pos.x + size.x && mouseY >= pos.y && mouseY < pos.y + size.y) {
            onClick();
        }
    }

    void activate() {
        active = true;
        if(buttonText != null) buttonText.activate();
    }
    void deactivate() {
        active = false;
        if(buttonText != null) buttonText.deactivate();
    }

    Button(PVector pos, PVector size, PImage sprite) {
        super(pos, size, sprite);
    }

    Button(PVector pos, PVector size, PImage sprite, String label, int col, int fontSize) {
        super(pos, size, sprite);
        buttonText = new Text(pos, size, label, col, fontSize, CENTER, CENTER);
    }

    Button(PVector pos, PVector size, int col) {
        super(pos, size, col);
    }

    Button(PVector pos, PVector size, int col, String label, int textCol, int fontSize) {
        super(pos, size, col);
        buttonText = new Text(pos, size, label, textCol, fontSize, CENTER, CENTER);
    }
}