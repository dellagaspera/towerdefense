static ArrayList<Enemy> enemies = new ArrayList<>();
static ArrayList<Enemy> deadEnemies = new ArrayList<>();

final int moneyPerPop = 50;

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
    new EnemyType(0.75f, 255, 80, 80),   // 1
    new EnemyType(0.80f, 80, 180, 255),  // 2
    new EnemyType(0.85f, 80, 180, 80),   // 3
    new EnemyType(0.90f, 255, 180, 80),  // 4
    new EnemyType(0.95f, 255, 255, 255), // 5
    new EnemyType(1.00f, 80, 80, 80),    // 6
    new EnemyType(1.05f, 200, 100, 100), // 7
    new EnemyType(1.10f, 100, 150, 255), // 8
    new EnemyType(1.15f, 100, 200, 100), // 9
    new EnemyType(1.20f, 255, 200, 100), // 10
    new EnemyType(1.25f, 255, 255, 200), // 11
    new EnemyType(1.30f, 100, 100, 100), // 12
    new EnemyType(1.35f, 255, 150, 150), // 13
    new EnemyType(1.40f, 150, 200, 255), // 14
    new EnemyType(1.45f, 150, 255, 150), // 15
    new EnemyType(1.50f, 255, 200, 150)  // 16
};

class Enemy {

    EnemyType type;

    PVector pos = new PVector();
    PVectorInt gridPos = new PVectorInt();

    PVector renderPosition = new PVector();

    int health = 1;
    int tintColor = color(255);
    float scale = 1;

    float damage = 1; // dano por ataque
    private float attackCooldown = 0.5; // Cooldown antes que o inimigo possa atacar novamente
    private float attackTimer = attackCooldown; // contador desde o último ataque

    float moveSpeed = 1.0;

    int walkDirection = 7;

    PImage sprite;

    private float bobbingTime = 0;

    void _update() {
        attackTimer += Time.scaledDeltaTime;
        update();

        
        bobbingTime = (Time.scaledDeltaTime * 6 + bobbingTime) % TWO_PI;
        float bobbing = -sin(bobbingTime) * tileSize / 8;
        float floatingHeight = -tileSize / 2;
        float scaleOffset = (1 - scale) * tileSize / 2;

        renderPosition.set(pos.x + scaleOffset, pos.y + scaleOffset + bobbing + floatingHeight);
    
        render();
    }

/*
    void walk() {
        // verifica se tem um objeto logo em cima. se tiver, tenta quebrar ele
        // (não garanto q funcione)
        if (!attack(gridPos))
            return;

        PVector nextNodePos = Map.getNextPositionFrom(gridPos);
        if (nextNodePos == null) {
            if (Map.reachedEnd(gridPos)) {
                // println("fim");
                hp -= health;
                die();
            }
            return;
        }

        boolean canMove;
        MapClass.Node nextNode = Map.getNodeFrom(nextNodePos);
        int limite = 22; // duas caixas
        if(nextNode != null && nextNode.custo > limite) canMove = true;
        else canMove = attack(new PVectorInt(nextNodePos));
        if (!canMove) {
            // se n pode andar, mas ta longe o suficiente, anda um pouco
            if (pos.dist(nextNodePos.copy().mult(tileSize)) > tileSize-10) {
                pos.add(PVector.sub(nextNodePos.copy().mult(tileSize), pos).normalize().mult(tileSize * moveSpeed * Time.scaledDeltaTime));
            }
        } else {
            // pode andar
            if (pos.dist(nextNodePos.copy().mult(tileSize)) < 1) { // perto o suficiente
                gridPos = new PVectorInt(nextNodePos);
                pos.set(gridPos.x * tileSize, gridPos.y * tileSize); // muda a posição para a posiçao exata da celula, evitando movimento estranho na diagonal 
            }
            pos.add(PVector.sub(nextNodePos.copy().mult(tileSize), pos).normalize().mult(tileSize * moveSpeed * Time.scaledDeltaTime));
        }

        // if(nextNodePos.x > gridPos.x) sprite = sprites.png.get("monkey_r");
        // if(nextNodePos.y < gridPos.y) sprite = sprites.png.get("monkey_u");
        // if(nextNodePos.x < gridPos.x) sprite = sprites.png.get("monkey_l");
        // if(nextNodePos.y > gridPos.y) sprite = sprites.png.get("monkey_d");
        sprite = sprites.png.get("monkey_d");
    }
*/
    void walk() {
        PVector nextNodePos = Map.getNextPositionFrom(gridPos);

        if (nextNodePos == null) {
            if (Map.reachedEnd(gridPos)) {
                hp -= health;
                die();
            }
            return;
        }

        PVectorInt nextNodeGridPos = new PVectorInt(nextNodePos);
        Structure target = structuresGrid.get(nextNodeGridPos);

        // Verifique se o próximo nó é um obstáculo
        // e se o custo dele é maior do que uma rota alternativa.
        // Obtenha o custo atual do caminho através do A*
        MapClass.Node nextNode = Map.getNodeFrom(nextNodeGridPos);
        if (target != null) {
            if(target.canBeAttacked != false) { 
                boolean canAttack = attack(nextNodeGridPos);
                if (!canAttack) {
                    return;
                }
            }
        }

        if(gridPos.y < nextNodeGridPos.y) walkDirection = 1; // ⬆️
        if(gridPos.x < nextNodeGridPos.x) walkDirection = 3; // ➡️
        if(gridPos.y > nextNodeGridPos.y) walkDirection = 5; // ⬇️
        if(gridPos.x > nextNodeGridPos.x) walkDirection = 7; // ⬅️
        
        if (pos.dist(nextNodePos.copy().mult(tileSize)) < 1) {
            gridPos = nextNodeGridPos;
            pos.set(gridPos.x * tileSize, gridPos.y * tileSize);
        } else {
            pos.add(PVector.sub(nextNodePos.copy().mult(tileSize), pos).normalize().mult(tileSize * moveSpeed / nextNode.custo * Time.scaledDeltaTime)); // anda mais lento o custo do proximo node for maior que 1
        }
        sprite = sprites.png.get("monkey" + walkDirection);
        // log("moveDirection=" + (int)moveDirection);
    }


    boolean attack(PVectorInt targetPosition) {
        Structure target = structuresGrid.get(targetPosition);
        if (target != null) {
            if (attackTimer < attackCooldown) return false;
            attackTimer = 0;
            target.attacked(damage);

            sounds.playSound("enemy_attack");

            return false;
        }
        return true;
    }

    void update() {
       walk();
    }

    void hurt(int dmg) {
        if(health <= 0) {
            logError("Tried to damage dead enemy!");
            return;
        }
        particlePresets.get("Explosion").spawn(renderPosition);
        money += min(health, dmg) * moneyPerPop;
    
        health -= dmg;

        sounds.playSound("enemy_pop");

        setType();

        if(health <= 0) die();
    }

    void die() {
        deadEnemies.add(this);
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
        float scaleOffset = (1 - scale) * tileSize / 2;
        image(sprites.png.get("shadow"), pos.x + scaleOffset, pos.y + scaleOffset, tileSize * scale, tileSize * scale);

        tint(tintColor);
        image(sprite, renderPosition.x, renderPosition.y, tileSize * scale, tileSize * scale);
        noTint();
    }

    Enemy(int health) {
        this.pos.set(gridPos.x * tileSize, gridPos.y * tileSize);
        this.health = health;
        
        setType();

        sprite = sprites.png.get("monkey_d");
    }

    Enemy(PVectorInt gridPos, Enemy source) {
        this.gridPos = gridPos;
        this.pos.set(gridPos.x * tileSize, gridPos.y * tileSize);
        this.health = source.health;

        setType();

        sprite = sprites.png.get("monkey_d");

        synchronized(enemies) {
            enemies.add(this);
        }
    }

    Enemy(PVectorInt gridPos, int health) {
        this.gridPos = gridPos;
        this.pos.set(gridPos.x * tileSize, gridPos.y * tileSize);
        this.health = health;

        setType();

        sprite = sprites.png.get("monkey_d");

        synchronized(enemies) {
            enemies.add(this);
        }
    }
}