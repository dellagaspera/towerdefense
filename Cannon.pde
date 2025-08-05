class Cannon extends Tower {
    float range = gridSize * 4;

    void render() {       
        if(canShoot) 
            image(cannon2, pos.x, pos.y);
        else
            image(cannon1, pos.x, pos.y);
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
    }

    boolean isInRange(PVector target) {
        if(pos.dist(target) <= range) return true;
        return false;
    }
}