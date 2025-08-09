SpriteManager sprites = new SpriteManager(new String[] {"cannon", "button"});

enum StructureType { Cannon };

final int tileSize = 48;

boolean buildMode = false;
StructureType selectedBuild = null;

void setup() {
    size(48 * 24, 48 * 16);
    frameRate(60);
    
    sprites.loadSprites();

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
    Text buildButtonLabel = new Text(buildButton, buildButton.size, "Build");

    Image buildPanel = new Image(new PVector(width - 200 - 5, 5), new PVector(200, height - buildButton.size.y - 15), sprites.map.get("button")) {
        void init() {
        }
        
        void update() {
            tintColor = color(120, 50, 20);
            isActive = buildMode;
        }
    };

    Image buildPanelCannon = new Image(buildPanel, new PVector(buildPanel.size.x - 10, 75), sprites.map.get("button")) {
        void onClick() {
            selectedBuild = StructureType.Cannon;
        }

        void update() {
            isActive = parent.isActive;

            if(selectedBuild == StructureType.Cannon) tintColor = color(120, 255, 120);
            else tintColor = color(255, 255, 255);
        }
    };
    Text buildPanelCannonLabel = new Text(buildPanelCannon, buildPanelCannon.size, "Cannon");
}

void draw() {
    background(60, 120, 40);

    for(UIObject o : uiObjects) {
        o._update();
    }

    for(Structure s : structures) {
        s._update();
    }
}

void build() {
    if(selectedBuild == null) return;

    if(selectedBuild == StructureType.Cannon) {
        new Structure(worldToGridPosition(new PVector(mouseX, mouseY)), sprites.map.get("cannon"));
    }
}

PVectorInt worldToGridPosition(PVector position) {
    return new PVectorInt((int)(position.x / tileSize), (int)(position.y / tileSize));
}

PVector gridToWorldPosition(PVectorInt position) {
    return new PVector(position.x * tileSize, position.y * tileSize);
}