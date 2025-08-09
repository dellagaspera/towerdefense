static ArrayList<Structure> structures = new ArrayList<>();

class Structure {
    PVectorInt position;
    PImage sprite = null;

    void _update() {
        update();

        render();
    }

    void update() {
        
    }

    void render() {
        stroke(255, 0, 0);
        fill(100, 100, 100);
        image(sprite, position.x * tileSize, position.y * tileSize, tileSize, tileSize);
        noStroke();
    }

    Structure(PVectorInt position, PImage sprite) {
        this.position = position;
        this.sprite = sprite;

        structures.add(this);
    }
}