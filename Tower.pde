enum Targeting {STRONGEST, WEAKEST, CLOSEST, FURTHEST};

class Tower extends Structure {

    float reloadDuration = 2;
    float reloadProgress = 0;
    boolean canShoot = true;

    int sellPrice;

    int damage = 1;
    int range = 3; // in tiles

    boolean aoe;
    int aoeDamage;
    float aoeRange;

    Targeting targeting = Targeting.CLOSEST;
    Enemy target = null;
    
    final Upgrade[] upgrades = new Upgrade[3];
    final boolean[] upgradedPaths = new boolean[3];

    void upgrade(int idx) {
        Upgrade u = upgrades[idx];
        upgradedPaths[idx] = true;
        if(u == null) return;

        switch(u.stat) {
            case DAMAGE:
                this.damage += u.effectI;
            break;
            case RANGE:
                this.range += u.effectI;
            break;
            case SHOOTING_SPEED:
                this.reloadDuration *= 1 - u.effectF;
            break;
            default:
                logError("Invalid Stat on Upgrade `" + u.name + "`!");
            break;
        }

        money -= u.cost;
        sellPrice += u.cost * 3/4;

        upgrades[idx] = u.unlocks;
    }

    boolean isValidUpgradePath(int idx) {
        int nPaths = 0;
        boolean isUpgraded = false;
        for(int i = 0; i < 3; i++) if(upgradedPaths[i]) {
            if(i == idx) isUpgraded = true;
            nPaths++;
        }
        if(nPaths >= 2 && !isUpgraded) return false;
        return true;
    }

    void shoot() {
        if(target == null) return;
        
        reloadProgress = 0;
        canShoot = false;

        target.hurt(damage);
        if(aoe) {
            
        }
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

    boolean isTower() {
        return true;
    }

    ArrayList<Enemy> findEnemiesInRange() {
        ArrayList<Enemy> inRange = new ArrayList<>();
        
        for(Enemy e : enemies) {
            if(new PVector(position.x, position.y).mult(tileSize).dist(e.pos) <= (range + 0.5) * tileSize) {
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
        if(targeting == Targeting.FURTHEST) {
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

        aoe = false;
    }

    public Tower(PVectorInt position, PImage sprite, int damage, float reloadDuration, int aoeDamage, float aoeRange) {
        super(position, sprite);
        this.damage = damage;
        this.reloadDuration = reloadDuration;

        aoe = true;
        this.aoeDamage = aoeDamage;
        this.aoeRange = aoeRange;
    }
}