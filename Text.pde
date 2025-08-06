class Text extends UIObject {
    String label = "New Text";
    int col = color(0, 0, 0);
    int fontSize = 16;
    int alignX = CENTER;
    int alignY = CENTER;

    void render() {
        if(!active) return;
        
        smooth();
        fill(col);
        textSize(fontSize);
        textAlign(alignX, alignY);
        text(label, pos.x, pos.y, size.x, size.y);
        noSmooth();
    }

    Text(PVector pos, PVector size, String label, int col, int fontSize, int alignX, int alignY) {
        super(pos, size);
        this.label = label;
        this.col = col;
        this.fontSize = fontSize;
        this.alignX = alignX;
        this.alignY = alignY;
    }
}