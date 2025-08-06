float health = initialHealth;
int money = initialMoney;

float deltaTime = 0;
float lastMillis = 0;

// usa esse objeto pra lidar com a tela. O processing
// me obriga a criar um objeto pra poder usar as funções de
// desenhar na tela :) (ou passar sempre um objeto PApplet)
UserInterface UI = new UserInterface();

int grid[][];

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
TextButton a = new TextButton(new PVector(200, 200), new PVector(200, 200), "OI");
void draw() {
    calculateDt();

    gameTick();

    UI.draw();
    a.render();
}

void updateGrid() {
    for(Structure s : structures) {

    }
}
