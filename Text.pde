PFont poppins12;
PFont poppins16;
PFont poppins32;
PFont poppins64;

class Text extends UIObject {
    String text;
    PFont font = poppins16;
    int textColor;
    Integer fontSize;
    int horizontalAlign;
    int verticalAlign;

    boolean textOutline;
    int outlineColor;

    boolean textBg;
    int bgColor;

    Text(PVector position, PVector size, String text) {
        super(position, size);
        this.text = text;
        if(fontSize == null) fontSize = 16;
        // init();
    }

    Text(UIObject parent, PVector size, String text) {
        super(parent, size);
        this.text = text;
        if(fontSize == null) fontSize = 16;
        // init();
    }

    Text(PVector position, PVector size) {
        super(position, size);
        if(fontSize == null) fontSize = 16;
        // init();
    }

    Text(UIObject parent, PVector size) {
        super(parent, size);
        if(fontSize == null) fontSize = 16;
        // init();
    }

    // Text(String text, PFont font) {
    //     this.text = text;
    //     this.font = font;
    // }

    void render() {
        noFill();
        noStroke();
        if(fontSize < 16) font = poppins12;
        else if(fontSize < 32) font = poppins16;
        else if(fontSize < 64) font = poppins32;
        else font = poppins64;
        textFont(font);
        textSize(fontSize);
        textAlign(horizontalAlign, verticalAlign);

        if(textBg) {
            fill(bgColor);
            float w = textWidth(text) + 8;
            float horizontalOffset = 0;

            switch(horizontalAlign) {
                case CENTER: horizontalOffset = (size.x - w) / 2; break;
                case LEFT: horizontalOffset = 0; break;
                case RIGHT: horizontalOffset = (size.x - w); break;
            }

            rect(realPosition.x + horizontalOffset, realPosition.y, w, size.y);
        }
        
        if(textOutline) {
            fill(outlineColor);
            for(int angle = 0; angle < 360; angle += 15) {
                text(text, realPosition.x + (cos(radians(angle)) * 3), realPosition.y + (sin(radians(angle)) * 4), size.x, size.y);
            }
        }

        fill(textColor);
        // println("textAlign(" + horizontalAlign + "," + verticalAlign + ");");
        text(text, int(realPosition.x), int(realPosition.y), size.x, size.y);

        // fill(0, 0, 0, 0);
        // stroke(255, 255, 0);
        // rect(realPosition.x, realPosition.y, size.x, size.y);
        // noStroke();
    }
}