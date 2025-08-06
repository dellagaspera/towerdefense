static ArrayList<Enemy> enemies = new ArrayList<>();
static ArrayList<Enemy> deadEnemies = new ArrayList<>();

class Enemy {
    PVector pos = new PVector();
    PVector target = new PVector();
    float maxHealth = 1;
    float health = 1;

    boolean aerial = false;

    float speed = 2;

    void update() {
        render();

        target = new PVector(mouseX, mouseY);
        move();

        if(health <= 0) deadEnemies.add(this);
    }

    void render() {
        fill(0, 80, 100);
        circle(pos.x, pos.y, 24);
    }

    void move() {
        PVector dir = PVector.sub(target, pos);
        dir.setMag(speed);
        pos.add(dir);
    }

    Enemy(PVector pos) {
        this.pos = pos;
        health = maxHealth;

        enemies.add(this);
    }

    Enemy(PVector pos, boolean aerial) {
        this.pos = pos;
        this.aerial = aerial;
        health = maxHealth;

        enemies.add(this);
    }
}