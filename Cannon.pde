class Cannon extends Tower {
    float range = gridSize * 4;
    Frame spriteFrame;

    void render() {       
        if(canShoot) 
            image(UI.sprites.get("cannon2"), pos.x, pos.y);
        else
            image(UI.sprites.get("cannon1"), pos.x, pos.y);
    }

    void shoot(Enemy e) {
        if(canShoot) {
            canShoot = false;
            shootCooldown = 0;

            e.health -= damage;
        }
    }

    Cannon(int x, int y) {
        super(x, y, true, false, 1.75, 3);
        spriteFrame = new Frame(new PVector(x*gridSize, y*gridSize), new PVector(gridSize, gridSize), UI.sprites.get("cannon1"));
    }

    boolean isInRange(PVector target) {
        if(pos.dist(target) <= range) return true;
        return false;
    }
}
