static ArrayList<Enemy> enemies = new ArrayList<>();

class Enemy {
    PVector pos = new PVector();
    PVectorInt gridPos = new PVectorInt();

    float damage = 10; // dano por ataque
    private float attackCooldown = 0.5; // Cooldown antes que o inimigo possa atacar novamente
    private float attackTimer = attackCooldown; // contador desde o último ataque

    float moveSpeed = 2;

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



    void render() {
        fill(255, 80, 80);
        circle(pos.x + 24, pos.y + 24, 24);
    }

    Enemy(PVectorInt gridPos) {
        this.gridPos = gridPos;
        this.pos.set(gridPos.x * tileSize, gridPos.y * tileSize);

        enemies.add(this);
    }
}