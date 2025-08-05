float health = 500;
float deltaTime = 0;
float lastMillis = 0;

int gridSize = 32;

int money = 1000;

void setup() {
    colorMode(HSB, 360, 100, 100);
    lastMillis = millis();
}

void settings() {
    size(gridSize * 32, gridSize * 18);
}

void draw() {
    background(0, 0, 0);

    float millis = millis();
    deltaTime = (millis - lastMillis) / 1000;
    lastMillis = millis;

    fill(0, 0, 100);
    text("health: " + health + "\nmoney: " + money, 10, 10);

    for(Structure s : structures) {
        s.update();
    }

    for(Enemy e : enemies) {
        e.update();
    }

    for(Enemy e : deadEnemies) {
        enemies.remove(e);
    }
    deadEnemies = new ArrayList<>();
}

void mouseReleased() {
    build();
}

void keyPressed() {
    if(key == 'e') {
        new Enemy(new PVector(mouseX, mouseY));
    }
}

void build() {
    money -= 100;

    new Tower((mouseX) / gridSize, mouseY / gridSize, true, false);
}