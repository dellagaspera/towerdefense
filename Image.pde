class Image extends UIObject {
    PImage sprite = null;

    boolean nineSlice = false;
    float sliceScale = 0.5;

    Integer hoverColor;
    Integer tintColor;

    void render() {
        stroke(255, 255, 0);
        fill(0, 0, 0);
        if(hover) {
            tint(red(hoverColor) * red(tintColor) / 255, green(hoverColor) * green(tintColor) / 255, blue(hoverColor) * blue(tintColor) / 255);
        } else tint(tintColor);
        if (sprite == null) rect(realPosition.x, realPosition.y, size.x, size.y);

        if(nineSlice && sprite != null) {
            int sliceWidth = (int)(sprite.width / 3);
            int sliceHeight = (int)(sprite.height / 3);
            
            image(sprite.get(0, 0, sliceWidth, sliceHeight), realPosition.x, realPosition.y, sliceWidth * sliceScale, sliceHeight * sliceScale);
            image(sprite.get(sliceWidth, 0, sliceWidth, sliceHeight), realPosition.x + sliceScale * sliceWidth, realPosition.y, size.x - 2 * sliceWidth * sliceScale, sliceHeight * sliceScale);
            image(sprite.get(sliceWidth * 2, 0, sliceWidth, sliceHeight), realPosition.x + size.x - sliceScale * sliceWidth, realPosition.y, sliceWidth * sliceScale, sliceHeight * sliceScale);
            
            image(sprite.get(0, 2 * sliceHeight, sliceWidth, sliceHeight), realPosition.x, realPosition.y + size.y - sliceHeight * sliceScale, sliceWidth * sliceScale, sliceHeight * sliceScale);
            image(sprite.get(sliceWidth, 2 * sliceHeight, sliceWidth, sliceHeight), realPosition.x + sliceScale * sliceWidth, realPosition.y + size.y - sliceHeight * sliceScale, size.x - 2 * sliceWidth * sliceScale, sliceHeight * sliceScale);
            image(sprite.get(sliceWidth * 2, 2 * sliceHeight, sliceWidth, sliceHeight), realPosition.x + size.x - sliceScale * sliceWidth, realPosition.y + size.y - sliceHeight * sliceScale, sliceWidth * sliceScale, sliceHeight * sliceScale);
            
            image(sprite.get(0, sliceHeight, sliceWidth, sliceHeight), realPosition.x, realPosition.y + sliceHeight * sliceScale, sliceWidth * sliceScale, size.y - 2 * sliceHeight * sliceScale);
            image(sprite.get(sliceWidth, sliceHeight, sliceWidth, sliceHeight), realPosition.x + sliceScale * sliceWidth, realPosition.y + sliceHeight * sliceScale, size.x - 2 * sliceWidth * sliceScale, size.y - 2 * sliceHeight * sliceScale);
            image(sprite.get(sliceWidth * 2, sliceHeight, sliceWidth, sliceHeight), realPosition.x + size.x - sliceScale * sliceWidth, realPosition.y + sliceHeight * sliceScale, sliceWidth * sliceScale, size.y - 2 * sliceHeight * sliceScale);
        } else if(sprite != null){
            image(sprite, realPosition.x, realPosition.y, size.x, size.y);
        }
        noStroke();
        noTint();
    }

    Image(PVector position, PVector size, PImage sprite) {
        super(position, size);
        this.sprite = sprite;

        if(hoverColor == null) hoverColor = color(255, 255, 255);
        if(tintColor == null) tintColor = color(255, 255, 255);
    }

    Image(UIObject parent, PVector size, PImage sprite) {
        super(parent, size);
        this.sprite = sprite;

        if(hoverColor == null) hoverColor = color(255, 255, 255);
        if(tintColor == null) tintColor = color(255, 255, 255);
    }
}