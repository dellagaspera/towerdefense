class ToggleButton extends Button {
    boolean state = false;

    void onClick() {
        state = !state;
    }

    void render() {
        if(sprite != null) {
            if(!state) image(sprite, pos.x, pos.y, size.x, size.y);
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

    ToggleButton(PVector pos, PVector size, PImage sprite, PImage hoverSprite) {
        super(pos, size, sprite, hoverSprite);
    }

    ToggleButton(PVector pos, PVector size, PImage sprite, PImage hoverSprite, String label, int col, int fontSize) {
        super(pos, size, sprite, hoverSprite);
        buttonText = new Text(pos, size, label, col, fontSize, CENTER, CENTER);
    }

    ToggleButton(PVector pos, PVector size, int col) {
        super(pos, size, col);
    }

    ToggleButton(PVector pos, PVector size, int col, String label, int textCol, int fontSize) {
        super(pos, size, col);
        buttonText = new Text(pos, size, label, textCol, fontSize, CENTER, CENTER);
    }
}