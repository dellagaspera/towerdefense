SpriteManager sprites = new SpriteManager(new String[] {
    "cannon", "button", "wall", "selectedPath",
    "dirts/grass", "dirts/dirt_15", "dirts/dirt_1", "dirts/dirt_2",
    "dirts/dirt_3", "dirts/dirt_4", "dirts/dirt_5", "dirts/dirt_6",
    "dirts/dirt_7", "dirts/dirt_8", "dirts/dirt_9", "dirts/dirt_10",
    "dirts/dirt_11", "dirts/dirt_12", "dirts/dirt_13", "dirts/dirt_14"});

final int tileSize = 48;
final int gridX = 24;
final int gridY = 16;

int nPath = 15;
int maxPathSize = 2*(gridX+gridY);

enum StructureType { Cannon, Wall };


boolean buildMode = false;
StructureType selectedBuild = null;

void settings() {
    size(tileSize * gridX, tileSize * gridY);

    noSmooth();
}

void setup() {
    frameRate(160);
    
    sprites.loadSprites();
    Map.generatePath();

    Image buildButton = new Image(new PVector(width - 100 - 5, height - 75 - 5), new PVector(100, 75), sprites.map.get("button")) {
        void init() {
            hoverColor = color(200, 200, 200);
        }

        void onClick() {
            buildMode = !buildMode;
        }

        void update() {
            if(buildMode) tintColor = color(180, 50, 50);
            else tintColor = color(50, 180, 50);
        }
    };
    buildButton.setPriority(3);
    Text buildButtonLabel = new Text(buildButton, buildButton.size, "Build");
    buildButtonLabel.setPriority(3);

    Image buildPanel = new Image(new PVector(width - 200 - 5, 5), new PVector(200, height - buildButton.size.y - 15), sprites.map.get("button")) {
        void init() {
        }
        
        void update() {
            tintColor = color(120, 50, 20);
            isActive = buildMode;
        }
    };
    buildPanel.setPriority(3);

    Image buildPanelCannon = new Image(buildPanel, new PVector(buildPanel.size.x - 10, 75), sprites.map.get("button")) {
        void init() {
            center.set(0.5, 0);
            anchor.set(0.5, 0);
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
    Text buildPanelCannonLabel = new Text(buildPanelCannon, buildPanelCannon.size, "Cannon");
    buildPanelCannonLabel.setPriority(3);

    Image buildPanelWall = new Image(buildPanel, new PVector(buildPanel.size.x - 10, 75), sprites.map.get("button")) {
        void init() {
            center.set(0.5, 0);
            anchor.set(0.5, 0);
            position.y = 75 + 10;
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
    Text buildPanelWallLabel = new Text(buildPanelWall, buildPanelWall.size, "Wall");
    buildPanelWallLabel.setPriority(3);

    setupBackground();

    new Enemy(new PVectorInt(Map.startPos));
}

void setupBackground() {
    MapClass.Node[][] path = Map.getPath();
    for (int i = 0; i < gridX; i++) {
        for (int j = 0; j < gridY; j++) {
            if (path[i][j] == null) {
                Image image = new Image(
                        new PVector(i * tileSize, j * tileSize),
                        new PVector(tileSize, tileSize),
                        sprites.map.get("dirts/grass")
                );
                image.isClickable = false;
                image.setPriority(1);
            } else {
                // bit-masking
                // 0 = no path (grass)
                // 1 = has path (dirt)

                int v = 0;
                if (i - 1 >= 0 && path[i - 1][j] != null) v += 1 << 0; // left (1)
                if (i + 1 < gridX && path[i + 1][j] != null) v += 1 << 1; // right (2)
                if (j - 1 >= 0 && path[i][j - 1] != null) v += 1 << 2; // top (4)
                if (j + 1 < gridY && path[i][j + 1] != null) v += 1 << 3; // bottom (8)

                Image image = new Image(
                        new PVector(i * tileSize, j * tileSize),
                        new PVector(tileSize, tileSize),
                        sprites.map.get("dirts/dirt_" + v)
                );
                image.isClickable = false;
                image.setPriority(1);
                path[i][j].image = image;
            }
        }
    }
}

void drawBackground() {
    MapClass.Node[][] path = Map.getPath();
    for (int i = 0; i < gridX; i++) {
        for (int j = 0; j < gridY; j++) {
            if (path[i][j] == null)
                image(sprites.map.get("dirts/grass"), i * tileSize, j * tileSize, tileSize, tileSize);
            // else path[i][j].sprite.render();
        }
    }
}

void draw() {
    Time.update();

    drawBackground();

    for (int i = 0; i <= maxRenderPriority; i++) {
        if(!priorityUiObjects.containsKey(i)) continue;
        for(UIObject o : priorityUiObjects.get(i)) {
            o._update();
        }
    }

    for(Structure s : structures) {
        s._update();
    }

    for(Enemy e : enemies) {
        e._update();
    }

    fill(255);
    textSize(16);
    text("FPS: " + int(1 / Time.deltaTime), 50, 50);
}

void build() {
    if(selectedBuild == null) return;

    switch (selectedBuild) {
        case Cannon:
            if (!clickingOnPath) new Structure(worldToGridPosition(new PVector(mouseX, mouseY)), sprites.map.get("cannon"));
            break;
        case Wall:
            new Wall(worldToGridPosition(new PVector(mouseX, mouseY)));
            break;
    }
}

PVectorInt worldToGridPosition(PVector position) {
    return new PVectorInt((int)(position.x / tileSize), (int)(position.y / tileSize));
}

PVector gridToWorldPosition(PVectorInt position) {
    return new PVector(position.x * tileSize, position.y * tileSize);
}