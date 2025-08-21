SpriteManager sprites = new SpriteManager();

final int tileSize = 48;
final int gridX = 24;
final int gridY = 16;

final String theme = "grassy";

int nPath = 3;
int nSpawner = 1;

int maxPathSize = 2*(gridX+gridY);

int pathMask[][] = new int[gridX][gridY];

enum StructureType { Cannon, Wall };

int money = 1000;

boolean buildMode = true;
StructureType selectedBuild = null;

int nextEnemy = 1;

void settings() {
    size(256 + tileSize * gridX, tileSize * gridY, P2D);

    // noSmooth();
}

void setup() {
    frameRate(160);

    poppins = createFont("assets/poppins.ttf", 128, true);
    
    sprites.loadSprites();
    Map.generatePath();

    generateBuildMenu();

    setupBackground();

    new Text(new PVector(12, 12), new PVector(120, 48), "FPS: ") {
        void init() {
            horizontalAlign = LEFT;
            verticalAlign = TOP;
        }

        void update() {
            text = "FPS: " + int(1 / Time.deltaTime);
        }
    };
}

void setupBackground() {
    MapClass.Node[][] path = Map.getPath();
    for (int i = 0; i < gridX; i++) {
        for (int j = 0; j < gridY; j++) {
            if (path[i][j] == null) {
                pathMask[i][j] = 0;
            } else {
                // bit-masking
                // 0 = no path (grass)
                // 1 = has path (dirt)

                int v = 0;
                if(i - 1 >= 0 && path[i - 1][j] != null) v += 1 << 0; // left (1)
                if ((i + 1 < gridX && path[i + 1][j] != null) || i - 1 >= gridX) v += 1 << 1; // right (2)
                if (j - 1 >= 0 && path[i][j - 1] != null) v += 1 << 2; // top (4)
                if (j + 1 < gridY && path[i][j + 1] != null) v += 1 << 3; // bottom (8)

                pathMask[i][j] = v;
            }
        }
    }
}

void drawBackground() {
    image(sprites.map.get(theme + "/bg"), 0, 0, width, height);
    MapClass.Node[][] path = Map.getPath();
    for (int i = 0; i < gridX; i++) {
        for (int j = 0; j < gridY; j++) {
            if(pathMask[i][j] == 0) continue;
            image(sprites.map.get(theme + "/dirt_" + pathMask[i][j]), i * tileSize, j * tileSize, tileSize, tileSize);
        }
    }
}

void draw() {
    Time.update();

    drawBackground();

    updateAll();

    fill(255);
    textSize(16);
    // text("FPS: " + int(1 / Time.deltaTime), 50, 50);

    if(frameCount % 1000 == 0) new Enemy(spawners[(int)random(0, nSpawner)], nextEnemy++);
}

void build() {
    if(selectedBuild == null) return;

    switch (selectedBuild) {
        case Cannon:
            if (!mouseOnPath) new Tower(worldToGridPosition(new PVector(mouseX, mouseY)), sprites.map.get("cannon"), 1, 2.5f);
            break;
        case Wall:
            if (mouseOnPath) new Wall(worldToGridPosition(new PVector(mouseX, mouseY)));
            break;
    }

    selectedBuild = null;
}

PVectorInt worldToGridPosition(PVector position) {
    return new PVectorInt((int)(position.x / tileSize), (int)(position.y / tileSize));
}

PVector gridToWorldPosition(PVectorInt position) {
    return new PVector(position.x * tileSize, position.y * tileSize);
}

void generateBuildMenu() {
    /*
    Image buildButton = new Image(new PVector(width - 48 - 4, height - 48 - 4), new PVector(48, 48), sprites.map.get("build_button")) {
        void init() {
            hoverColor = color(200, 200, 200);
        }

        void onClick() {
            buildMode = !buildMode;
        }

        void update() {
            if(buildMode) sprite = sprites.map.get("build_button_pressed");
            else sprite = sprites.map.get("build_button");
        }
    };
    buildButton.setPriority(3);
    */
    Image buildPanel = new Image(new PVector(width - 240, 0), new PVector(240, 768), sprites.map.get("build_panel")) {
        void update() {
            // isActive = buildMode;
        }
    };
    buildPanel.setPriority(3);

    Image buildPanelCannon = new Image(buildPanel, new PVector(216, 144), sprites.map.get("blueprint")) {
        void init() {
            anchor.set(0, 0);
            center.set(0, 0);
            position.set(12, 36);
        }
        
        void onClick() {
            selectedBuild = StructureType.Cannon;
        }

        void update() {
            isActive = parent.isActive;

            if(selectedBuild == StructureType.Cannon) tintColor = color(120, 255, 120);
            else tintColor = color(255, 255, 255);
        }
    };
    buildPanelCannon.setPriority(3);

    Image buildPanelWall = new Image(buildPanel, new PVector(216, 144), sprites.map.get("blueprint")) {
        void init() {
            anchor.set(0, 0);
            center.set(0, 0);
            position.set(12, 36 + 144);
        }
        
        void onClick() {
            selectedBuild = StructureType.Wall;
        }

        void update() {
            isActive = parent.isActive;

            if(selectedBuild == StructureType.Wall) tintColor = color(120, 255, 120);
            else tintColor = color(255, 255, 255);
        }
    };
    buildPanelWall.setPriority(3);
}

void updateAll() {
    for(Enemy e : deadEnemies) {
        enemies.remove(e);
    }
    deadEnemies = new ArrayList<>();

    for(Structure s : structures) {
        s._update();
    }

    for(Enemy e : enemies) {
        e._update();
    }
    
    for (int i = 0; i <= maxRenderPriority; i++) {
        if(!priorityUiObjects.containsKey(i)) continue;
        for(UIObject o : priorityUiObjects.get(i)) {
            o._update();
        }
    }
}