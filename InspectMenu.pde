class InspectMenu extends Image {
    Text title = null;
    Button sell = null;
    Text info = null;

    void update() {
        if(inspectSelection != null) {
            render();
            title.activate();
            sell.activate();
            info.activate();
        } else {
            title.deactivate();
            sell.deactivate();
            info.deactivate();
        }
    }

    InspectMenu() {
        super(new PVector(10, 10), new PVector(320, height - 20), null);
        title = new Text(pos, new PVector(size.x, 64), "Title", color(0, 0, 100), 32, CENTER, CENTER) {
            void update() {
                if(!active) return;
                if(inspectSelection != null && inspectSelection instanceof Cannon) label = "Cannon";
                else label = "Error";

                render();
            }
        };

        sell = new Button(new PVector(pos.x + 5, pos.y + size.y - 5 - 32), new PVector(size.x - 10, 32), color(0, 80, 70), "Sell", color(0, 0, 100), 16) {
            void onClick() {
                money += 100;
                structures.remove(inspectSelection);
                strucuresMap.remove((int)(inspectSelection.pos.x / gridSize) + (int)(inspectSelection.pos.y / gridSize) * gridX);
                inspectSelection = null;
            }
        };

        info = new Text(new PVector(pos.x + 10, pos.y + 64 + 10), new PVector(size.x - 20, 128), "-", color(0, 0, 100), 16, LEFT, TOP) {
            void update() {
                if(!active) return;
                if(inspectSelection != null && inspectSelection instanceof Cannon) {
                    Cannon c = (Cannon)inspectSelection;
                    label = "Damage: " + c.damage + "\nRange: " + c.range / gridSize + "\nFire Rate: " + (int)(100 / c.shootDelay);
                }

                render();
            }
        };
    }
}