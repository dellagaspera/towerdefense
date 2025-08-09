float health = initialHealth;
int money = initialMoney;

// Se o mouse está em cima de qualquer coisa da interface
boolean mouseOverUI = false;

float deltaTime = 0;
float lastMillis = 0;



int grid[][];
int path[][];

/**
 * Configura o jogo
 */
void settings() {
    UI.settingsUI();
}

/**
 * Inicializa o jogo
 */
void setup() {
    UI.setupUI();

    lastMillis = millis();
    grid = new int[gridX][gridY];
    Map.generatePath();
}

/**
 * Calcula o deltaTime
 */
void calculateDt() {
    float millis = millis();
    deltaTime = (millis - lastMillis) / 1000;
    lastMillis = millis;
}

/**
 * Atualiza o jogo a cada frame
 */
void gameTick() {
    // Lógica do jogo
    for(Structure s : structures) {
        s.update();
    }
    for(Enemy e : enemies) {
        e.update();
    }
    for(Enemy e : deadEnemies) {
        enemies.remove(e);
    }
    deadEnemies.clear();
}

void draw() {
    calculateDt();
    gameTick();
    UI.draw();
    // termina o frame resetando o mouse
    mouseDown = false;
    mouseUp = false;
}

void updateGrid() {
    for(Structure s : structures) {

    }
}
