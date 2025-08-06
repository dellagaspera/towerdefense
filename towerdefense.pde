import java.util.Map;

float deltaTime = 0;
float lastMillis = 0;

int gridSize = 64;
final int gridX = 24;
final int gridY = 12;

int money = 100;

HashMap<Integer, Structure> strucuresMap;

Structure buildSelection = null;
Structure inspectSelection = null;

void setup() {
    colorMode(HSB, 360, 100, 100);
    lastMillis = millis();
    noStroke();
    noSmooth(); 
    size(64 * 24, 64 * 12);

    strucuresMap = new HashMap<>();

    loadSprites();

    new Text(new PVector(width - 5 - 240, 5), new PVector(240, 32), "Money: ", color(0, 0, 100), 32, CENTER, CENTER) {
        void update() {
            label = "Money: " + money;
            render();
        }
    };

    new InspectMenu();
}

void draw() {
    background(110, 60, 60);

    float millis = millis();
    deltaTime = (millis - lastMillis) / 1000;
    lastMillis = millis;

    update();

    if(frameCount % 60 > 30) image(selection1, (int)(mouseX / gridSize) * gridSize, (int)(mouseY / gridSize) * gridSize);
    else image(selection2, (int)(mouseX / gridSize) * gridSize, (int)(mouseY / gridSize) * gridSize);

    if(inspectSelection != null) {
        if(frameCount % 60 > 30) image(inspect_selection1, inspectSelection.pos.x, inspectSelection.pos.y);
        else image(inspect_selection2, inspectSelection.pos.x, inspectSelection.pos.y);
    }
}

void mouseReleased() {
    if(buildSelection != null) build();
    else inspect();
}

void keyPressed() {
    if(key == 'e') {
        new Enemy(new PVector(mouseX, mouseY));
    } else {
        build();
    }
}

void build() {
    int x = mouseX / gridSize;
    int y = mouseY / gridSize;

    if(x < 0 || x >= gridX - 1 || y < 0 || y >= gridY - 1 || strucuresMap.containsKey(y * gridX + x)) return;

    money -= 100;

    strucuresMap.put(y * gridX + x, new Cannon(x, y));
}

void inspect() {
    int x = mouseX / gridSize;
    int y = mouseY / gridSize;

    if(x < 0 || x >= gridX - 1 || y < 0 || y >= gridY - 1) return;

    inspectSelection = strucuresMap.get(y * gridX + x);
}

void updateGrid() {
    for(Structure s : structures) {

    }
}

void update() {
    for(Structure s : structures) {
        s.update();
    }

    for(Enemy e : enemies) {
        e.update();
    }

    for(Enemy e : deadEnemies) {
        money += 50 * e.maxHealth;
        enemies.remove(e);
    }
    deadEnemies = new ArrayList<>();

    for(UIObject o : uiObjects) {
        o.update();
    }
}

PImage cannon1 = null;
PImage cannon2 = null;
PImage selection1 = null;
PImage selection2 = null;
PImage inspect_selection1 = null;
PImage inspect_selection2 = null;
void loadSprites() {
    cannon1 = loadImage("sprites/cannon1.png");
    cannon2 = loadImage("sprites/cannon2.png");
    selection1 = loadImage("sprites/selection1.png");
    selection2 = loadImage("sprites/selection2.png");
    inspect_selection1 = loadImage("sprites/inspect_selection1.png");
    inspect_selection2 = loadImage("sprites/inspect_selection2.png");
}