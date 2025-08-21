PFont poppins;

class Text extends UIObject {
    String text;
    PFont font = poppins;
    int textColor = color(0, 0, 0);
    int fontSize = 16;
    int horizontalAlign;
    int verticalAlign;

    Text(PVector position, PVector size, String text) {
        super(position, size);
        this.text = text;
        // init();
    }

    Text(UIObject parent, PVector size, String text) {
        super(parent, size);
        this.text = text;
        // init();
    }

    // Text(String text, PFont font) {
    //     this.text = text;
    //     this.font = font;
    // }

    void render() {
        textFont(font);
        fill(textColor);
        textSize(fontSize);
        textAlign(horizontalAlign, verticalAlign);
        // println("textAlign(" + horizontalAlign + "," + verticalAlign + ");");
        text(text, realPosition.x, realPosition.y, size.x, size.y);

        // fill(0, 0, 0, 0);
        // stroke(255, 255, 0);
        // rect(realPosition.x, realPosition.y, size.x, size.y);
        // noStroke();
    }
}