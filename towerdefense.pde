float health = initialHealth;
int money = initialMoney;

// Se o mouse está em cima de qualquer coisa da interface
boolean mouseOverUI = false;

float deltaTime = 0;
float lastMillis = 0;

// usa esse objeto pra lidar com a tela. O processing
// me obriga a criar um objeto pra poder usar as funções de
// desenhar na tela :) (ou passar sempre um objeto PApplet)
UserInterface UI = new UserInterface();

int grid[][];

Frame a;
Button b;

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

    a = new Frame(UI.cannon2, new Text("Teste", color(0, 0, 100)));
    a.strokeWeight = 16;
    a.hasStroke = true;
    b = new Button(new PVector((gridSize*gridX)/2-100, 50), new PVector(200, 50), a);
    b.onClick = () -> {
        println("OI");
    };

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
    deadEnemies = new ArrayList<>();
}

int v = 0;
void draw() {
    calculateDt();
    gameTick();

    UI.draw();
    // a.render();
    v = (v+1)%255;
    a.strokeColor = color(255-v, 100, 50);
}

void updateGrid() {
    for(Structure s : structures) {

    }
}
