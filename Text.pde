class Text extends UIObject {
    String text;
    PFont font;
    int textColor = color(0, 0, 0);
    int fontSize = 32;

    Text(PVector position, PVector size, String text) {
        super(position, size);
        this.text = text;
    }

    Text(UIObject parent, PVector size, String text) {
        super(parent, size);
        this.text = text;
    }

    // Text(String text, PFont font) {
    //     this.text = text;
    //     this.font = font;
    // }

    void render() {
        fill(textColor);
        textSize(fontSize);
        textAlign(CENTER, CENTER);
        text(text, realPosition.x, realPosition.y, size.x, size.y);
        
        fill(0, 0, 0, 0);
        stroke(255, 255, 0);
        rect(realPosition.x, realPosition.y, size.x, size.y);
    }
}