class Button extends Image {
    Text buttonText = null;
    PImage hoverSprite = null;

    boolean hover = false;

    void onClick() {

    }

    void update() {
        if(!active) return;

        if(mouseX >= pos.x && mouseX < pos.x + size.x && mouseY >= pos.y && mouseY < pos.y + size.y) {
            hover = true;
            if(mousePressed) onClick();
        } else hover = false;
        
        render();
    }

    void render() {
        if(sprite != null) {
            if(!hover) image(sprite, pos.x, pos.y, size.x, size.y);
            else image(hoverSprite, pos.x, pos.y, size.x, size.y);
        }
        else {
            fill(col);
            rect(pos.x, pos.y, size.x, size.y);
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

    Button(PVector pos, PVector size, PImage sprite, PImage hoverSprite) {
        super(pos, size, sprite);
        this.hoverSprite = hoverSprite;
    }

    Button(PVector pos, PVector size, PImage sprite, PImage hoverSprite, String label, int col, int fontSize) {
        super(pos, size, sprite);
        this.hoverSprite = hoverSprite;
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