static ArrayList<Tower> towers = new ArrayList<>();

class Tower extends Structure {
    float range = gridSize * 4;

    float shootCooldown = 0;
    float shootDelay = 0.75;
    boolean canShoot = true;
    float damage = 5;

    boolean ground = false;
    boolean aerial = false;

    void update() {
        render();

        if(canShoot) {
            for(Enemy e : enemies) {
                if(isInRange(e.pos)) {
                    if((e.aerial && aerial) || (!e.aerial && ground)) {
                        shoot(e);
                        break;
                    }
                }
            }
        }

        shootCooldown += deltaTime;

        if(shootCooldown >= shootDelay) {
            canShoot = true;
        }
    }

    void render() {        
        fill(80, 40, 100);
        if(canShoot)
            fill(80, 80, 100);
        circle(pos.x, pos.y, 40);
    }

    void shoot(Enemy e) {
        if(canShoot) {
            canShoot = false;
            shootCooldown = 0;

            e.health -= damage;
        }
    }

    Tower(int x, int y, boolean ground, boolean aerial) {
        super(x, y);

        this.ground = ground;
        this.aerial = aerial;
    }

    boolean isInRange(PVector target) {
        if(pos.dist(target) <= range) return true;
        return false;
    }
}