static ArrayList<Enemy> enemies = new ArrayList<>();
static ArrayList<Enemy> deadEnemies = new ArrayList<>();

class EnemyType {
    float scale = 1;
    int tintColor = color(255);
    int r, g, b;

    public EnemyType(float scale, int r, int g, int b) {
        this.scale = scale;
        this.r = r;
        this.g = g;
        this.b = b;
    }
}

EnemyType enemyTypes[] = {
    new EnemyType(0.85f, 255, 80, 80),
    new EnemyType(0.85f, 80, 180, 255),
    new EnemyType(0.85f, 80, 180, 80),
    new EnemyType(0.85f, 255, 180, 80),
    new EnemyType(1.15f, 255, 255, 255),
    new EnemyType(1.35f, 80, 80, 80)
};
class Enemy {

    EnemyType type;

    PVector pos = new PVector();
    PVectorInt gridPos = new PVectorInt();

    int health = 1;
    int tintColor = color(255);
    float scale = 1;

    float damage = 10; // dano por ataque
    private float attackCooldown = 0.5; // Cooldown antes que o inimigo possa atacar novamente
    private float attackTimer = attackCooldown; // contador desde o último ataque

    float moveSpeed = 2;
    PImage sprite;

    private float bobbing = 0.1;
    private float bobbingCount = 0;

    void _update() {
        attackTimer += Time.deltaTime;
        update();

        render();
    }

    void walk() {
        // verifica se tem um objeto logo em cima. se tiver, tenta quebrar ele
        // (não garanto q funcione)
        if (!attack(gridPos))
            return;

        PVector nextNode = Map.getNextPositionFrom(gridPos);
        if (nextNode == null) {
            if (Map.reachedEnd(gridPos)) {
                println("fim");
            }
            return;
        }

        boolean canMove = attack(new PVectorInt(nextNode));
        if (!canMove) {
            // se n pode andar, mas ta longe o suficiente, anda um pouco
            if (pos.dist(nextNode.copy().mult(tileSize)) > tileSize-10) {
                pos.add(PVector.sub(nextNode.copy().mult(tileSize), pos).normalize().mult(tileSize * moveSpeed * Time.deltaTime));
            }
        } else {
            // pode andar
            if (pos.dist(nextNode.copy().mult(tileSize)) < 1)
                gridPos = new PVectorInt(nextNode);;
            pos.add(PVector.sub(nextNode.copy().mult(tileSize), pos).normalize().mult(tileSize * moveSpeed * Time.deltaTime));
        }

        // if(nextNode.x > gridPos.x) sprite = sprites.map.get("monkey_r");
        // if(nextNode.y < gridPos.y) sprite = sprites.map.get("monkey_u");
        // if(nextNode.x < gridPos.x) sprite = sprites.map.get("monkey_l");
        // if(nextNode.y > gridPos.y) sprite = sprites.map.get("monkey_d");
        sprite = sprites.map.get("monkey_d");
    }

    boolean attack(PVectorInt targetPosition) {
        Structure target = structuresGrid.get(targetPosition);
        if (target != null) {
            if (attackTimer < attackCooldown) return false;
            attackTimer = 0;
            target.attacked(damage);
            return false;
        }
        return true;
    }

    void update() {
       walk();
    }

    void hurt(int dmg) {
        money += dmg + min(0, health - damage);
    
        health -= dmg;

        setType();

        if(health <= 0) die();
    }

    void die() {
        enemies.remove(this);
    }

    void setType() {
        if(health < 1 || health - 1 >= enemyTypes.length) {
            scale = 1;
            tintColor = color(255);

            return;
        }
        scale = enemyTypes[health - 1].scale;
        tintColor = color(enemyTypes[health - 1].r, enemyTypes[health - 1].g, enemyTypes[health - 1].b);
    }

    void render() {
        bobbingCount += Time.deltaTime;
        bobbingCount = bobbingCount % TWO_PI;

        PVector offset = new PVector(pos.x - (tileSize * (1 - scale)) / 2, pos.y - tileSize * (scale - 1) - (tileSize * (1 - scale) / 2));

        image(sprites.map.get("shadow"), pos.x, pos.y, tileSize, tileSize);

        tint(tintColor);
        // image(sprite, offset.x, offset.y + sin(bobbingCount / bobbing) * 3 - 24, tileSize * scale, tileSize * scale);
        image(sprite, pos.x, pos.y + sin(bobbingCount / bobbing) * 3 - tileSize/2, tileSize, tileSize);
        noTint();
    }

    Enemy(PVectorInt gridPos, int health) {
        this.gridPos = gridPos;
        this.pos.set(gridPos.x * tileSize, gridPos.y * tileSize);
        this.health = health;

        setType();

        enemies.add(this);
    }
}