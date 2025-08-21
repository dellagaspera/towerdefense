static ArrayList<Structure> structures = new ArrayList<>();
static HashMap<PVectorInt, Structure> structuresGrid = new HashMap<>();

class Structure {
    PVectorInt position;
    PImage sprite = null;
    int weight = 1;

    void _update() {
        update();

        render();
    }

    void update() {
        
    }

    void _destroy() {
        structures.remove(this);
        structuresGrid.remove(position);
        destroy();
    }

    void attacked(float damage) {

    }

    void destroy() {

    }

    void render() {
        image(sprite, position.x * tileSize, position.y * tileSize, tileSize, tileSize);
        noStroke();
    }

    Structure(PVectorInt position, PImage sprite) {
        this.position = position;
        this.sprite = sprite;
        Map.setWeight(position, weight);

        structures.add(this);
        structuresGrid.put(position, this);
    }
}