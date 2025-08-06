static enum TargetSorting {CLOSEST, STRONGEST, WEAKEST};

class Tower extends Structure {

    float range = gridSize * 4;

    float shootCooldown = 0;
    float shootDelay = 0.75;
    boolean canShoot = true;
    float damage = 5;

    boolean ground = false;
    boolean aerial = false;

    TargetSorting targetSort = TargetSorting.CLOSEST;

    void update() {
        render();

        if(canShoot) {
            Enemy target = chooseTarget(possibleTargets());

            if(target != null) shoot(target);
        }

        if(shootCooldown >= shootDelay) {
            canShoot = true;
        } else shootCooldown += deltaTime;
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

    Tower(int x, int y, boolean ground, boolean aerial, float shootDelay, float damage) {
        super(x, y);

        this.ground = ground;
        this.aerial = aerial;

        this.shootDelay = shootDelay;
        this.damage = damage;
    }

    boolean isInRange(PVector target) {
        if(pos.dist(target) <= range) return true;
        return false;
    }

    Enemy[] possibleTargets() {
        Enemy[] targets = new Enemy[0];
        
        for(Enemy e : enemies) {
            if(isInRange(e.pos) && !(!aerial && e.aerial) && !(!ground && !e.aerial) && e.health > 0) {
                targets = (Enemy[])append(targets, e);
            }
        }

        return targets;
    }

    Enemy chooseTarget(Enemy[] targets) {
        Enemy target = null;

        if(targetSort == TargetSorting.CLOSEST) {
            float closestDist = 9999999;
            for(Enemy e : targets) {
                if(pos.dist(e.pos) <= closestDist) {
                    target = e;
                    closestDist = pos.dist(e.pos);
                }
            }
        } else if(targetSort == TargetSorting.STRONGEST) {
            float mostHealth = -1;
            for(Enemy e : targets) {
                if(e.health > mostHealth) {
                    target = e;
                    mostHealth = e.health;
                }
            }
        } else if(targetSort == TargetSorting.WEAKEST) {
            float leastHealth = 9999999;
            for(Enemy e : targets) {
                if(e.health < leastHealth) {
                    target = e;
                    leastHealth = e.health;
                }
            }
        }

        return target;
    }
}