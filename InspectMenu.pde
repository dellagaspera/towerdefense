InspectMenu inspectMenu = null;

void clearInspectMenu() {
    if(inspectMenu != null) {
        inspectMenu.name.removeObject();
        inspectMenu.dmg.removeObject();
        inspectMenu.dps.removeObject();
        inspectMenu.range.removeObject();
        inspectMenu.fireRate.removeObject();
        inspectMenu.target.removeObject();
        inspectMenu.targetLabel.removeObject();
        for(int i = 0; i < 3; i++) {
            inspectMenu.upgrades[i].removeObject();
            inspectMenu.upgradeNames[i].removeObject();
            inspectMenu.upgradeCosts[i].removeObject();
            inspectMenu.upgradeDescriptions[i].removeObject();
        }
        inspectMenu.sell.removeObject();
        inspectMenu.sellLabel.removeObject();

        inspectMenu.removeObject();
        inspectMenu = null;
    }
}

class InspectMenu extends Image {
    Text name;
    Text dmg, dps, range, fireRate;
    Image target;
    Text targetLabel;
    Image[] upgrades = new Image[3];
    Text[] upgradeNames = new Text[3];
    Text[] upgradeCosts = new Text[3];
    Text[] upgradeDescriptions = new Text[3];
    Image sell;
    Text sellLabel;

    Tower selected;

    public InspectMenu(Tower t) {
        super(gridToWorldPosition(t.position).add(-tileSize, tileSize), new PVector(240, 336), sprites.png.get("inspect_menu"));
        selected = t;

        canBeDragged = true;

        clearInspectMenu();

        PVector offsetPosition = new PVector(-tileSize, - size.y);
        this.position = gridToWorldPosition(t.position).add(offsetPosition);
        this.size = new PVector(240, 336);

        if(position.x + size.x > width - buildMenuWidth) position.x -= (position.x + size.x) - (width - buildMenuWidth);
        if (position.x < 0) position.x = 0;
        if (position.y < 0) position.y = gridToWorldPosition(t.position).y + tileSize;

        String towerName = "IDK";
        if(t instanceof Cannon) towerName = "Canhão";
        name = new Text(this, new PVector(216, 22), towerName) {
            void init() {
                anchor.set(0, 0);
                center.set(0, 0);

                position.set(13, 13);
                
                horizontalAlign = CENTER;
                verticalAlign = CENTER;

                fontSize = 12;

                textColor = color(255);
            }
        };

        dmg = new Text(this, new PVector(216, 22), str(t.damage)) {
            void init() {
                anchor.set(0, 0);
                center.set(0, 0);

                position.set(13, 37);
                
                horizontalAlign = LEFT;
                verticalAlign = CENTER;

                fontSize = 12;

                textColor = color(255);
            }

            void update() {
                text = "Dano: " + t.damage;
            }
        };
        
        dps = new Text(this, new PVector(216, 22), t.damage / t.reloadDuration + "/s") {
            void init() {
                anchor.set(0, 0);
                center.set(0, 0);

                position.set(13, 37);
                
                horizontalAlign = RIGHT;
                verticalAlign = CENTER;

                fontSize = 12;

                textColor = color(255);
            }

            void update() {
                text = "DPS: " + String.format("%.2f/s", t.damage / t.reloadDuration);
            }
        };

        fireRate = new Text(this, new PVector(216, 22), 1 / t.reloadDuration + "/s") {
            void init() {
                anchor.set(0, 0);
                center.set(0, 0);

                position.set(13, 61);
                
                horizontalAlign = LEFT;
                verticalAlign = CENTER;

                fontSize = 12;

                textColor = color(255);
            }

            void update() {
                text = "Disparos /s: " + String.format("%.2f/s", 1 / t.reloadDuration);
            }
        };

        range = new Text(this, new PVector(216, 22), t.range + " blocos") {
            void init() {
                anchor.set(0, 0);
                center.set(0, 0);

                position.set(13, 85);
                
                horizontalAlign = LEFT;
                verticalAlign = CENTER;

                fontSize = 12;

                textColor = color(255);
            }

            void update() {
                text = "Alcance: " + t.range + " blocos";
            }
        };

        target = new Image(this, new PVector(216, 22), sprites.png.get("target")) {
            void init() {
                anchor.set(0, 0);
                center.set(0, 0);

                position.set(14, 120);

                tintColor = color(120, 180, 255);
            }

            void onClick() {
                switch(t.targeting) {
                    case STRONGEST: t.targeting = Targeting.WEAKEST; break;
                    case WEAKEST: t.targeting = Targeting.FURTHEST; break;
                    case FURTHEST: t.targeting = Targeting.CLOSEST; break;
                    case CLOSEST: t.targeting = Targeting.STRONGEST; break;
                }
            }
        };
        targetLabel = new Text(target, new PVector(216, 20), "Alvo: null") {
            void init() {
                anchor.set(0, 0);
                center.set(0, 0);

                position.set(0, -2);
            
                horizontalAlign = CENTER;
                verticalAlign = CENTER;

                fontSize = 12;

                textColor = color(255);
            }

            void update() {
                String alvo = "erro";
                
                switch(t.targeting) {
                    case STRONGEST: alvo = "Mais Forte"; break;
                    case WEAKEST: alvo = "Mais Fraco"; break;
                    case FURTHEST: alvo = "Mais Longe"; break;
                    case CLOSEST: alvo = "Mais Perto"; break;
                }
                text = "Alvo: " + alvo;
            }
        };

        for(int i = 0; i < 3; i++) {
            final int i_ = i;
            upgrades[i] = new Image(this, new PVector(20, 22), sprites.png.get("upgrade")){
                void init() {
                    anchor.set(0, 0);
                    center.set(0, 0);

                    position.set(14, 158 + 48 * i_);
                }

                void update() {
                    if(t.upgrades[i_] == null) tintColor = color(34, 32, 52);
                    else if(money < t.upgrades[i_].cost) {
                        tintColor = color(255, 120, 120);
                        isClickable = false;
                    } else if(t.isValidUpgrade(i_) == false) {
                        tintColor = color(34, 32, 52);
                        isClickable = false;
                    } else {
                        tintColor = color(120, 255, 120);
                        isClickable = true;
                    }
                }

                void onClick() {
                    t.upgrade(i_);
                }
            };
            upgradeNames[i] = new Text(this, new PVector(188, 22)){
                void init() {
                    anchor.set(0, 0);
                    center.set(0, 0);

                    horizontalAlign = LEFT;
                    verticalAlign = CENTER;

                    textColor = color(255);

                    fontSize = 16;

                    position.set(38, 158 + 48 * i_);
                }

                void update() {
                    if(t.upgrades[i_] == null) text = "MAX";
                    else text = t.upgrades[i_].name;
                }
            };
            upgradeCosts[i] = new Text(this, new PVector(188, 22)){
                void init() {
                    anchor.set(0, 0);
                    center.set(0, 0);

                    horizontalAlign = RIGHT;
                    verticalAlign = CENTER;

                    textColor = color(255);

                    fontSize = 16;

                    position.set(38, 158 + 48 * i_);
                }

                void update() {
                    if(t.upgrades[i_] == null) text = "";
                    else text = t.upgrades[i_].cost + "$";
                }
            };
            upgradeDescriptions[i] = new Text(this, new PVector(216, 22)){
                void init() {
                    anchor.set(0, 0);
                    center.set(0, 0);

                    horizontalAlign = LEFT;
                    verticalAlign = CENTER;

                    fontSize = 12;

                    textColor = color(255);

                    position.set(14, 182 + 48 * i_);
                }

                void update() {
                    if(t.upgrades[i_] == null) text = " ";
                    else text = t.upgrades[i_].description;
                }
            };
        }

        sell = new Image(this, new PVector(216, 20), sprites.png.get("sell")) {
            void init() {
                anchor.set(0, 0);
                center.set(0, 0);

                position.set(14, 302);

                tintColor = color(255, 120, 120);
            }

            void onClick() {
                money += t.sellPrice;
                t._destroy();

                clearInspectMenu();
            }
        };
        sellLabel = new Text(sell, new PVector(216, 20), "Vender") {
            void init() {
                anchor.set(0, 0);
                center.set(0, 0);

                position.set(0, -2);
            
                horizontalAlign = CENTER;
                verticalAlign = CENTER;

                fontSize = 12;

                textColor = color(255);
            }

            void update() {
                text = "Vender: " + t.sellPrice;
            }
        };

        inspectMenu = this;
    }
}