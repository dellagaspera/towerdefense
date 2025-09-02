SpriteManager sprites = new SpriteManager();
SoundManager sounds = new SoundManager(this);
Prices buildCosts = new Prices();

final int tileSize = 48;
final int gridX = 24;
final int gridY = 17;

final String theme = "grassy";

int nPath = 2;
int nSpawner = 1;

int maxPathSize = 2*(gridX+gridY);

int pathMask[][] = new int[gridX][gridY];

enum StructureType { Cannon, Wall, Sand };

enum GameState { Win, Running, Lose };

int hp = 1;
int money = 1000;

int waveReward = 250;

int waveCount;
int wavesPlayed = 0;

boolean buildMode = true;
StructureType selectedBuild = null;

WaveManager wm = new WaveManager();

int nextEnemy = 1;

final int buildMenuWidth = 256;

ArrayList<PVectorInt> bestPath = new ArrayList<>();
boolean drawPath = true;

GameState gameState = GameState.Running;

void settings() {
    size(buildMenuWidth + tileSize * gridX, tileSize * gridY, P2D);

    // noSmooth();
}

void setup() {
    poppins16 = createFont("assets/fonts/poppins.ttf", 16, true);
    poppins12 = createFont("assets/fonts/poppins.ttf", 12, true);
    poppins32 = createFont("assets/fonts/poppins.ttf", 32, true);
    poppins64 = createFont("assets/fonts/poppins.ttf", 64, true);
    
    sprites.loadSprites();
    sounds.loadSounds();
    
    wm.readWaves();
    waveCount = wm.waves.size();

    Map.generatePath();

    generateParticlePresets();
    
    setBuildCosts();

    setupBackground();

    setupUI();
    
    findBestPath();
}

void defeat() {
    Time.timeScale = 0;

    gameState = GameState.Lose;
}

void win() {
    Time.timeScale = 0;

    gameState = GameState.Win;
}

void setupBackground() {
    MapClass.Node[][] path = Map.getPath();
    for (int i = 0; i < gridX; i++) {
        for (int j = 0; j < gridY - 1; j++) {
            if (path[i][j] == null) {
                pathMask[i][j] = 0;
            } else {
                // bit-masking
                // 0 = no path (grass)
                // 1 = has path (dirt)

                int v = 0;
                if(i - 1 >= 0 && path[i - 1][j] != null) v += 1 << 0; // left (1)
                if ((i + 1 < gridX && path[i + 1][j] != null) || i + 1 >= gridX) v += 1 << 1; // right (2)
                if (j - 1 >= 0 && path[i][j - 1] != null) v += 1 << 2; // top (4)
                if (j + 1 < gridY-1 && path[i][j + 1] != null) v += 1 << 3; // bottom (8)

                pathMask[i][j] = v;
            }
        }
    }
}

void setupUI() {
    generateBuildMenu();
    generateBottomBar();

    /*
    new Text(new PVector(0, height - 24), new PVector(120, 24)) {
        void init() {
            horizontalAlign = LEFT;
            verticalAlign = BOTTOM;

            textBg = true;
            bgColor = color(0, 0, 0, 128);
        }

        void update() {
            if(int(1 / Time.averageDeltaTime) <= 40)textColor = color(255, 120, 120);
            else textColor = color(120, 255, 120);

            text = "FPS: " + int(1 / Time.averageDeltaTime);
        }
    };
    */
}

void drawBackground() {
    image(sprites.png.get(theme + "/bg"), 0, 0, width, height);
    MapClass.Node[][] path = Map.getPath();
    for (int i = 0; i < gridX; i++) {
        for (int j = 0; j < gridY; j++) {
            if(pathMask[i][j] == 0) continue;
            image(sprites.png.get(theme + "/dirt_" + pathMask[i][j]), i * tileSize, j * tileSize, tileSize, tileSize);
        }
    }
}

void drawCore() {
    image(sprites.png.get("core"), Map.endPos.x * tileSize, Map.endPos.y * tileSize, tileSize, tileSize);
}

// void startWave() {
//     wm.startWave();
// }

void draw() {
    Time.update();
    mouseOnPath = Map.getNodeFrom(worldToGridPosition(new PVector(mouseX, mouseY))) != null;

    if(gameState == GameState.Running) {
        if(hp <= 0) defeat();
        if(!wm.onWave && wm.waves.size() == 0) win();
    }

    drawBackground();
    drawCore();
    if(drawPath)drawBestPath();

    drawBuildOverlay();
    if(inspectMenu != null) drawRange(inspectMenu.selected);

    updateAll();

    fill(255);
    textSize(16);
    // text("FPS: " + int(1 / Time.scaledDeltaTime), 50, 50);

    if(gameState == GameState.Lose) drawDefeatScreen();
    if(gameState == GameState.Win) drawWinScreen();
}

void drawDefeatScreen() {
    fill(120, 60, 60, 128);
    rect(0, 0, width, height);
    
    UIObject panel = new UIObject(new PVector(0, 0), new PVector(width, height));

    new Text(panel, new PVector(width / 2, height / 2), "perdeu!") {
        void init() {
            horizontalAlign = CENTER;
            verticalAlign = CENTER;

            fontSize = 64;

            textColor = color(194, 45, 67);

            anchor.set(0.5, 0.5);
            center.set(0.5, 0.5);
        }
    };
}

void drawWinScreen() {
    fill(120, 210, 255, 128);
    rect(0, 0, width, height);
    
    UIObject panel = new UIObject(new PVector(0, 0), new PVector(width, height));

    new Text(panel, new PVector(width / 2, height / 2), "ganhou!") {
        void init() {
            horizontalAlign = CENTER;
            verticalAlign = CENTER;

            fontSize = 64;

            textColor = color(245, 173, 66);

            anchor.set(0.5, 0.5);
            center.set(0.5, 0.5);
        }
    };
}

void findBestPath() {
    bestPath.clear();
    
    for (int i = 0; i < nSpawner; i++) {
      PVectorInt gridPos = spawners[i];   
    PVectorInt nextPos = null;
      do {
          if (!bestPath.contains(gridPos)) bestPath.add(gridPos);
          if(Map.getNextPositionFrom(gridPos) != null) nextPos = new PVectorInt(Map.getNextPositionFrom(gridPos));
          else break;
          
          gridPos = nextPos;
      } while(nextPos != null);
    }
}

void drawBestPath() {
    for(PVectorInt v : bestPath) {
        noStroke();
        fill(255, 255, 255, 128);
        circle((v.x + 0.5) * tileSize, (v.y + 0.5) * tileSize, 5);
    }
}

void drawBuildOverlay() {
    if(selectedBuild == null) return;

    PVectorInt gridPosition = new PVectorInt(new PVector(mouseX, mouseY).mult(1.0/tileSize));
    PVector position = new PVector(gridPosition.x, gridPosition.y).add(0.5, 0.5).mult(tileSize);

    switch (selectedBuild) {
        case Cannon:
            if (!mouseOnPath && isValidBuildPosition(gridPosition)) {
                drawRange(position, 2);

                image(sprites.png.get("cannon_outline"), position.x - tileSize / 2,  position.y - tileSize / 2, tileSize, tileSize);
            } else {
                tint(255, 120, 120);
                image(sprites.png.get("cannon_outline"), position.x - tileSize / 2,  position.y - tileSize / 2, tileSize, tileSize);
                noTint();
            }
        break;
        case Wall:
            if (mouseOnPath && isValidBuildPosition(gridPosition)) {
                image(sprites.png.get("wall_outline"), position.x - tileSize / 2,  position.y - tileSize / 2, tileSize, tileSize);
            } else {
                tint(255, 120, 120);
                image(sprites.png.get("wall_outline"), position.x - tileSize / 2,  position.y - tileSize / 2, tileSize, tileSize);
                noTint();
            }
        break;
        case Sand:
            if (mouseOnPath && isValidBuildPosition(gridPosition)) {
                image(sprites.png.get("sand_outline"), position.x - tileSize / 2,  position.y - tileSize / 2, tileSize, tileSize);
            } else {
                tint(255, 120, 120);
                image(sprites.png.get("sand_outline"), position.x - tileSize / 2,  position.y - tileSize / 2, tileSize, tileSize);
                noTint();
            }
        break;
    }
}

void drawRange(Tower t) {
    PVector position = gridToWorldPosition(t.position).add(tileSize / 2, tileSize / 2);
    fill(120, 255, 120, 120);
    stroke(120, 255, 120);
    circle(position.x, position.y, (t.range + 0.5) * tileSize * 2);
    noStroke();
    noFill();
}

void drawRange(PVector position, int range) {
    fill(120, 255, 120, 120);
    stroke(120, 255, 120);
    circle(position.x, position.y, (range + 0.5) * tileSize * 2);
    noStroke();
    noFill();
}

boolean isValidBuildPosition(PVectorInt gridPosition) {
    if(structuresGrid.get(gridPosition) != null) return false;
    if(gridPosition.x < 0 || gridPosition.x >= gridX || gridPosition.y < 0 || gridPosition.y >= gridY) return false;

    return true;
}

boolean build() {
    if(selectedBuild == null) return false;

    PVectorInt gridPosition = worldToGridPosition(new PVector(mouseX, mouseY));

    if(!isValidBuildPosition(gridPosition)) return false;

    switch (selectedBuild) {
        case Cannon:
            if (!mouseOnPath) {
                new Cannon(gridPosition);
                money -= buildCosts.prices.get("Cannon");
            }
            break;
        case Wall:
            if (mouseOnPath) {
                new Wall(gridPosition);
                money -= buildCosts.prices.get("Wall");
            }
            break;
        case Sand:
            if (mouseOnPath) {
                new Sand(gridPosition);
                money -= buildCosts.prices.get("Sand");
            }
            break;
    }

    selectedBuild = null;

    findBestPath();

    return true;
}

PVectorInt worldToGridPosition(PVector position) {
    return new PVectorInt((int)(position.x / tileSize), (int)(position.y / tileSize));
}

PVector gridToWorldPosition(PVectorInt position) {
    return new PVector(position.x * tileSize, position.y * tileSize);
}

void generateBuildMenu() {
    Image buildPanel = new Image(new PVector(width - 240, 0), new PVector(240, 768), sprites.png.get("build_panel")) {
        void update() {
            // isActive = buildMode;
        }
    };

    Text title = new Text(buildPanel, new PVector(240, 25), "CONSTRUIR") {
        void init() {
            anchor.set(0, 0);
            center.set(0, 0);

            horizontalAlign = CENTER;
            verticalAlign = CENTER;

            textColor = color(255);
        }
    };

    Image buildPanelCannon = new Image(buildPanel, new PVector(216, 144), sprites.png.get("blueprint_canhao")) {
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
            isClickable = money >= buildCosts.prices.get("Cannon");

            if(isClickable) {
                if(selectedBuild == StructureType.Cannon) tintColor = color(120, 255, 120);
                else tintColor = color(255, 255, 255);
            } else {
                if(selectedBuild == StructureType.Cannon) selectedBuild = null; //só de garantia
                tintColor = color(255, 120, 120);
            }
        }
    };

    Text buildPanelCannonLabel = new Text(buildPanelCannon, new PVector(216, 24)) {
        void init() {
            anchor.set(0, 1);
            center.set(0, 1.25);

            horizontalAlign = CENTER;
            verticalAlign = CENTER;
            textColor = color(255, 255, 255);
            
            textOutline = true;

            text = buildCosts.prices.get("Cannon") + "$";
        }

        void update() {
            if(buildPanelCannon.isClickable) {
                if(selectedBuild == StructureType.Cannon) outlineColor = color(63 * 120 / 255, 63 * 255 / 255, 63 * 120 / 255);
                else outlineColor = color(63, 63, 116);
            } else {
                outlineColor = color(63 * 255 / 255, 63 * 120 / 255, 116 * 120 / 255);
            }
        }
    };

    Image buildPanelWall = new Image(buildPanel, new PVector(216, 144), sprites.png.get("blueprint_wall")) {
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
            isClickable = money >= buildCosts.prices.get("Wall");

            if(isClickable) {
                if(selectedBuild == StructureType.Wall) tintColor = color(120, 255, 120);
                else tintColor = color(255, 255, 255);
            } else {
                if(selectedBuild == StructureType.Wall) selectedBuild = null; //só de garantia
                tintColor = color(255, 120, 120);
            }
        }
    };

    Text buildPanelWallLabel = new Text(buildPanelWall, new PVector(216, 24)) {
        void init() {
            anchor.set(0, 1);
            center.set(0, 1.25);

            horizontalAlign = CENTER;
            verticalAlign = CENTER;
            textColor = color(255, 255, 255);

            textOutline = true;

            text = buildCosts.prices.get("Wall") + "$";
        }

        void update() {
            if(buildPanelWall.isClickable) {
                if(selectedBuild == StructureType.Wall) outlineColor = color(63 * 120 / 255, 63 * 255 / 255, 63 * 120 / 255);
                else outlineColor = color(63, 63, 116);
            } else {
                outlineColor = color(63 * 255 / 255, 63 * 120 / 255, 116 * 120 / 255);
            }
        }
    };

    Image buildPanelSand = new Image(buildPanel, new PVector(216, 144), sprites.png.get("blueprint_sand")) {
        void init() {
            anchor.set(0, 0);
            center.set(0, 0);
            position.set(12, 36 + 288);
        }
        
        void onClick() {
            selectedBuild = StructureType.Sand;
        }

        void update() {
            isActive = parent.isActive;
            isClickable = money >= buildCosts.prices.get("Sand");

            if(isClickable) {
                if(selectedBuild == StructureType.Sand) tintColor = color(120, 255, 120);
                else tintColor = color(255, 255, 255);
            } else {
                if(selectedBuild == StructureType.Sand) selectedBuild = null; //só de garantia
                tintColor = color(255, 120, 120);
            }
        }
    };

    Text buildPanelSandLabel = new Text(buildPanelSand, new PVector(216, 24)) {
        void init() {
            anchor.set(0, 1);
            center.set(0, 1.25);

            horizontalAlign = CENTER;
            verticalAlign = CENTER;
            textColor = color(255, 255, 255);

            textOutline = true;

            text = buildCosts.prices.get("Sand") + "$";
        }

        void update() {
            if(buildPanelSand.isClickable) {
                if(selectedBuild == StructureType.Sand) outlineColor = color(63 * 120 / 255, 63 * 255 / 255, 63 * 120 / 255);
                else outlineColor = color(63, 63, 116);
            } else {
                outlineColor = color(63 * 255 / 255, 63 * 120 / 255, 116 * 120 / 255);
            }
        }
    };
}

void generateBottomBar() {
    Image panel = new Image(new PVector(0, height - 48), new PVector(width, 48), sprites.png.get("bottom_bar"));
    // money
    new Image(panel, new PVector(20, 20), sprites.png.get("coin")) {
        void init() {
            anchor.set(0, 0);
            center.set(0, 0);

            position.set(3, 3);
        }
    };
    new Text(panel, new PVector(120, 20)) {
        void init() {
            horizontalAlign = LEFT;
            verticalAlign = CENTER;

            anchor.set(0, 0);
            center.set(0, 0);

            position.set(3 + 24, 3);

            textColor = color(255);
        }

        void update() {
            text = (money + "$");
        }
    };

    // hp
    new Image(panel, new PVector(20, 20), sprites.png.get("heart")) {
        void init() {
            anchor.set(0, 0);
            center.set(0, 0);

            position.set(3, 26);
        }
    };
    new Text(panel, new PVector(120, 20)) {
        void init() {
            horizontalAlign = LEFT;
            verticalAlign = CENTER;

            anchor.set(0, 0);
            center.set(0, 0);

            position.set(3 + 24, 26);

            textColor = color(255);
        }

        void update() {
            text = (str(hp));
        }
    };

    Image startRound = new Image(panel, new PVector(128, 40), sprites.png.get("start_round")) {

        void init() {
            anchor.set(1, 1);
            center.set(1, 1);

            position.set(-4, -4);
        }

        void onClick() {
            wm.startWave();
        }

        void update() {
            if(wm.onWave) tintColor = color(255, 120, 120);
            else tintColor = color(120, 255, 120);
        }
    };

    new Text(startRound, new PVector(128, 35), "Iniciar") {
        void init() {
            horizontalAlign = CENTER;
            verticalAlign = CENTER;

            anchor.set(0, 0);
            center.set(0, 0);

            textColor = color(255);
        }
    };

    new Text(panel, new PVector(128, 35), "0/0") {
        void init() {
            horizontalAlign = RIGHT;
            verticalAlign = CENTER;

            anchor.set(1, 1);
            center.set(1, 1);

            position.set(-136, -4);

            textColor = color(255);
        }

        void update() {
            text = wavesPlayed + "/" + waveCount;
        }
    };
}

void updateAll() {
    for(Enemy e : deadEnemies) {
        enemies.remove(e);
    }
    deadEnemies = new ArrayList<>();

    boolean ponWave = wm.onWave;
    if(wm.currentWave == null) wm.onWave = false;
    if(enemies.size() == 0 && wm.currentWave != null && !wm.currentWave.spawning) wm.onWave = false;
    if(ponWave && !wm.onWave) {
        money += waveReward;
        wavesPlayed++;
    }

    for(Particle p : deadParticles) {
        particles.remove(p);
    }
    deadParticles = new ArrayList<>();

    for(Structure s : structures) {
        s._update();
    }

    for(Enemy e : enemies) {
        e._update();
    }
    
    for(Particle p : particles) {
        p._update();
    }
    
    for(UIObject o : uiObjectsToRemove) {
        uiObjects.remove(o);
    }
    uiObjectsToRemove = new ArrayList<>();
    
    for(UIObject o : uiObjects) {
        o._update();
    }

    // for(int i = 0; i < gridX; i++)
    //     for(int j = 0; j < gridY; j++)
    //         if(Map.getNodeFrom(new PVectorInt(i, j)) != null)text(str(Map.getNodeFrom(new PVectorInt(i, j)).custo), i * tileSize, j * tileSize, tileSize, tileSize);
}

void generateParticlePresets() {
    particlePresets.put("Explosion", new Particle(
        new PImage[] {
            sprites.png.get("particles/explosion1"),
            sprites.png.get("particles/explosion2"),
            sprites.png.get("particles/explosion3"),
            sprites.png.get("particles/explosion4"),
            sprites.png.get("particles/explosion5")
        },
        new PVector(tileSize, tileSize),
        0.25
        ));
}

void setBuildCosts() {
    buildCosts.prices.put("Wall", 275);
    buildCosts.prices.put("Cannon", 500);
    buildCosts.prices.put("Sand", 375);
}
