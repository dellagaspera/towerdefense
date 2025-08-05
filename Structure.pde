static ArrayList<Structure> structures = new ArrayList<>();

class Structure {
    PVector pos = new PVector();

    void update() {
        render();
    }

    void render() {
        fill(80, 80, 100);
        circle(pos.x, pos.y, 24);
    }

    Structure(int x, int y) {
        this.pos = new PVector(x * gridSize + gridSize / 2, y * gridSize + gridSize / 2);
        structures.add(this);
    }
}