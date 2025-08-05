float health = 500;
float deltaTime = 0;
float lastMillis = 0;

int gridSize = 64;
final int gridX = 24;
final int gridY = 12;

int money = 1000;

int grid[][];

// void settings() {
//     size(gridSize * gridX, gridSize * gridY);
// }

void setup() {
    colorMode(HSB, 360, 100, 100);
    lastMillis = millis();
    noStroke();
    noSmooth(); 
    // size(gridSize * gridX, gridSize * gridY);
    size(64 * 24, 64 * 12);

    grid = new int[gridX][gridY];

    loadSprites();
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
    int x = mouseX / gridSize;
    int y = mouseY / gridSize;

    if(x < 0 || x >= gridX - 1 || y < 0 || y >= gridY - 1) return;

    money -= 100;

    new Cannon(x, y);
}

void updateGrid() {
    for(Structure s : structures) {

    }
}

PImage cannon1 = null;
PImage cannon2 = null;
void loadSprites() {
    cannon1 = loadImage("sprites/cannon1.png");
    cannon2 = loadImage("sprites/cannon2.png");
}