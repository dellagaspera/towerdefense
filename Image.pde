class Image extends UIObject {
    PImage sprite = null;
    int col = 0;

    void render() {
        if(sprite != null) image(sprite, pos.x, pos.y, size.x, size.y);
        else {
            fill(col);
            rect(pos.x, pos.y, size.x, size.y);
        }
    }

    Image(PVector pos, PVector size, PImage sprite) {
        super(pos, size);
        this.sprite = sprite;
    }

    Image(PVector pos, PVector size, int col) {
        super(pos, size);
        this.col = col;
    }
}