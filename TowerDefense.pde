SpriteManager sprites = new SpriteManager(new String[] {"cannon", "button", "path", "selectedPath"});

final int tileSize = 48;
final int gridX = 24;
final int gridY = 16;

int nPath = 3;
int maxPathSize = 2*(gridX+gridY);

enum StructureType { Cannon };


boolean buildMode = false;
StructureType selectedBuild = null;

void settings() {
    size(tileSize * gridX, tileSize * gridY);
}

void setup() {

    frameRate(60);
    
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

}

void draw() {
    background(60, 120, 40);

    for (int i = 0; i <= maxRenderPriority; i++) {
        if(!priorityUiObjects.containsKey(i)) continue;
        for(UIObject o : priorityUiObjects.get(i)) {
            o._update();
        }
    }

    for(Structure s : structures) {
        s._update();
    }
}

void build() {
    if(selectedBuild == null) return;

    switch (selectedBuild) {
        case Cannon:
            if (!clickingOnPath) new Structure(worldToGridPosition(new PVector(mouseX, mouseY)), sprites.map.get("cannon"));
            break;
        /*case Tower:
            new Structure(worldToGridPosition(new PVector(mouseX, mouseY)), sprites.map.get("tower"));
            break;*/
    }
}

PVectorInt worldToGridPosition(PVector position) {
    return new PVectorInt((int)(position.x / tileSize), (int)(position.y / tileSize));
}

PVector gridToWorldPosition(PVectorInt position) {
    return new PVector(position.x * tileSize, position.y * tileSize);
}