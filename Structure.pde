static ArrayList<Structure> structures = new ArrayList<>();
static HashMap<PVectorInt, Structure> structuresGrid = new HashMap<>();

class Structure {
    PVectorInt position;
    PImage sprite = null;
    int weight = 1;
    int cost;

    boolean canBeAttacked;
    boolean isPath;

    void _update() {
        update();

        render();
    }

    void update() {
        
    }

    void _destroy() {
        structures.remove(this);
        structuresGrid.remove(position);

        sounds.playSound("structure_destroy");
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

    boolean isTower() {
        return false;
    }

    Structure(PVectorInt position, PImage sprite) {
        this.position = position;
        this.sprite = sprite;
        canBeAttacked = false;
        isPath = false;

        sounds.playSound("structure_build");

        structures.add(this);
        structuresGrid.put(position, this);
    }

    Structure(PVectorInt position, PImage sprite, boolean canBeAttacked) {
        this.position = position;
        this.sprite = sprite;
        this.canBeAttacked = canBeAttacked;
        isPath = true;

        sounds.playSound("structure_build");

        structures.add(this);
        structuresGrid.put(position, this);
    }
}