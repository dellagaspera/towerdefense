static ArrayList<Structure> structures = new ArrayList<>();
static HashMap<PVectorInt, Structure> structuresGrid = new HashMap<>();

class Structure {
    PVectorInt position;
    Image sprite = null;
    int weight = 1;

    void _update() {
        update();

        render();
    }

    void update() {
        
    }

    void _destroy() {
        sprite.removeObject();
        structures.remove(this);
        structuresGrid.remove(position);
        destroy();
    }

    void attacked(float damage) {

    }

    void destroy() {

    }

    void render() {
        // PImage da estrutura trocada por um objeto Image
        /*stroke(255, 0, 0);
        fill(100, 100, 100);
        image(sprite, position.x * tileSize, position.y * tileSize, tileSize, tileSize);
        noStroke();*/

        // (não precisa dessa linha abaixo)
        // sprite.render();
    }

    Structure(PVectorInt position, PImage sprite) {
        this.position = position;
        this.sprite = new Image(
                new PVector(position.x * tileSize, position.y * tileSize),
                new PVector(tileSize, tileSize),
                sprite
        );
        this.sprite.setPriority(2);
        Map.setWeight(position, weight);

        structures.add(this);
        structuresGrid.put(position, this);
    }
}