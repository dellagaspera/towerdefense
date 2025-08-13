SpriteManager sprites = new SpriteManager(new String[] {
    "cannon", "button", "path", "selectedPath", 
    "grass", "dirt", "dirt_r", "dirt_l", 
    "dirt_t", "dirt_b", "dirt_tr", "dirt_tl", 
    "dirt_br", "dirt_bl", "dirt_tb", "dirt_lr",
    "dirt_ltr", "dirt_trb", "dirt_rbl", "dirt_blt"});

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

    new Enemy(new PVectorInt(Map.startPos));
}

void draw() {
    Time.update();

    MapClass.Node[][] path = Map.getPath();
    for(int i = 0; i < gridX; i++) {
        for(int j = 0; j < gridY; j++) {
            if(path[i][j] == null)
                image(sprites.map.get("grass"), i * tileSize, j * tileSize, tileSize, tileSize);
            else {
                boolean l = false, r = false, t = false, b = false;
                if(i + 1 < gridX) if(path[i + 1][j] != null) l = true;
                if(j + 1 < gridY) if(path[i][j + 1] != null) t = true;
                if(i - 1 >= 0) if(path[i - 1][j] != null) r = true;
                if(j - 1 >= 0) if(path[i][j - 1] != null) b = true;
                PImage sprite = sprites.map.get("dirt");
                if(!b && l && r && t) sprite = sprites.map.get("dirt_t");
                if(b && l && !r && t) sprite = sprites.map.get("dirt_l");
                if(b && !l && r && t) sprite = sprites.map.get("dirt_r");
                if(b && l && r && !t) sprite = sprites.map.get("dirt_b");
                
                if(b && !l && r && !t) sprite = sprites.map.get("dirt_br");
                if(b && l && !r && !t) sprite = sprites.map.get("dirt_bl");
                if(!b && !l && r && t) sprite = sprites.map.get("dirt_tr");
                if(!b && l && !r && t) sprite = sprites.map.get("dirt_tl");
                
                if(!b && !l && !r && t) sprite = sprites.map.get("dirt_ltr");
                if(!b && !l && r && !t) sprite = sprites.map.get("dirt_trb");
                if(b && !l && !r && !t) sprite = sprites.map.get("dirt_rbl");
                if(!b && l && !r && !t) sprite = sprites.map.get("dirt_blt");

                if(b && !l && !r && t) sprite = sprites.map.get("dirt_lr");
                if(!b && l && r && !t) sprite = sprites.map.get("dirt_tb");
                image(sprite, i * tileSize, j * tileSize, tileSize, tileSize);
                // textSize(10);
                // text("b " + b + "\nt " + t + "\nr " + r + "\nl " + l, i * tileSize, j * tileSize, tileSize, tileSize);
            }
        }
    }

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