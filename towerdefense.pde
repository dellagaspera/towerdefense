float health = initialHealth;
int money = initialMoney;

float deltaTime = 0;
float lastMillis = 0;

// usa esse objeto pra lidar com a tela. O processing
// me obriga a criar um objeto pra poder usar as funções de
// desenhar na tela :) (ou passar sempre um objeto PApplet)
UserInterface UI = new UserInterface();

int grid[][];


void settings() {
    UI.settingsUI();
}

void setup() {
    UI.setupUI();

    lastMillis = millis();
    grid = new int[gridX][gridY];
}

void calculateDt() {
    float millis = millis();
    deltaTime = (millis - lastMillis) / 1000;
    lastMillis = millis;
}

void gameTick() {
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

void draw() {
    calculateDt();

    gameTick();

    UI.draw();
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
