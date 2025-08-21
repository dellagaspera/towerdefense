enum Targeting {STRONGEST, WEAKEST, CLOSEST, FURTHERST};

class Tower extends Structure {

    float reloadDuration = 2;
    float reloadProgress = 0;
    boolean canShoot = true;

    int damage = 1;
    int range = 3; // in tiles

    Targeting targeting = Targeting.CLOSEST;
    Enemy target = null;

    void shoot() {
        if(target == null) return;
        
        reloadProgress = 0;
        canShoot = false;

        target.hurt(damage);
    }

    void update() {
        setTarget();

        if(canShoot && target != null) {
            shoot();
        } else {
            reloadProgress += Time.deltaTime;
            if(reloadProgress >= reloadDuration) canShoot = true;
        }
    }

    ArrayList<Enemy> findEnemiesInRange() {
        ArrayList<Enemy> inRange = new ArrayList<>();
        
        for(Enemy e : enemies) {
            if(new PVector(position.x, position.y).mult(tileSize).dist(e.pos) <= range * tileSize) {
                inRange.add(e);
            }
        }

        return inRange;
    }

    void setTarget() {
        ArrayList<Enemy> inRange = findEnemiesInRange();
        if(inRange.size() == 0) { 
            target = null; 
            return; 
        } else target = inRange.get(0);

        if(targeting == Targeting.CLOSEST) {
            float temp = position.dist(inRange.get(0).pos);
            for(Enemy e : inRange) {
                float dist = new PVector(position.x, position.y).mult(tileSize).dist(e.pos);
                if(dist < temp) {
                    temp = dist;
                    target = e;
                }
            }
        }
        if(targeting == Targeting.FURTHERST) {
            float temp = position.dist(inRange.get(0).pos);
            for(Enemy e : inRange) {
                float dist = new PVector(position.x, position.y).mult(tileSize).dist(e.pos);
                if(dist > temp) {
                    temp = dist;
                    target = e;
                }
            }
        }
        if(targeting == Targeting.WEAKEST) {
            int temp = inRange.get(0).health;
            for(Enemy e : inRange) {
                int hp = e.health;
                if(hp < temp) {
                    temp = hp;
                    target = e;
                }
            }
        }
        if(targeting == Targeting.STRONGEST) {
            int temp = inRange.get(0).health;
            for(Enemy e : inRange) {
                int hp = e.health;
                if(hp > temp) {
                    temp = hp;
                    target = e;
                }
            }
        }
    }

    public Tower(PVectorInt position, PImage sprite, int damage, float reloadDuration) {
        super(position, sprite);
        this.damage = damage;
        this.reloadDuration = reloadDuration;
    }
}