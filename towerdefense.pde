float health = starterHealth;
int money = starterMoney;

float deltaTime = 0;
float lastMillis = 0;

// usa esse objeto pra lidar com a tela. O processing
// me obriga a criar um objeto pra poder usar as funções de
// desenhar na tela :) (ou passar sempre um objeto PApplet)
__class__UI UI = new __class__UI();

void setup() {
    lastMillis = millis();
    colorMode(HSB, 360, 100, 100);
}

void settings() {
    size(gridSize * length, gridSize * height);
}

// Calcula o DeltaTime
void calculateDt() {
    float millis = millis();
    deltaTime = (millis - lastMillis) / 1000;
    lastMillis = millis;
}

/**
 * Atualiza o jogo e processa um novo frame
 */
void gameTick() {
    // Calcula o DeltaTime
    calculateDt();

    // Atualiza o jogo
    for(Enemy e : deadEnemies) {
        enemies.remove(e);
    }
    deadEnemies = new ArrayList<>();
}

void draw() {

    // Atualiza o jogo
    gameTick();

    // Desenha as coisas na tela
    UI.draw();
}

void build() {
    money -= 100;

    new Tower((mouseX) / gridSize, mouseY / gridSize, true, false);
}