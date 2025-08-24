class Wall extends Structure {
    static final int weight = 1;
    final float maxHealth = 10;
    float health = maxHealth;
    // Text healthText;

    public Wall(PVectorInt position) {
        super(position, sprites.png.get("wall1"));
        Map.setWeight(position, weight + (int)health);

        // healthText = new Text(
        //         gridToWorldPosition(position),
        //         new PVector(tileSize, tileSize),
        //         "100%"
        // );
        // healthText.textColor = color(0, 255, 0);
        // healthText.fontSize = 16;
    }

    public void attacked(float damage) {
        health -= damage;
        if(health <= maxHealth / 2) {
            sprite = sprites.png.get("wall2");
            if(health + damage > maxHealth / 2) particlePresets.get("Explosion").spawn(new PVector(position.x * tileSize, position.y * tileSize));
        }
        Map.setWeight(position, weight + (int)health);
        if (health <= 0) {
            _destroy();
            return;
        }
    }

    public void update() {
        PVector pos = gridToWorldPosition(position);
        float percentage = health/maxHealth;

        // healthText.text = String.format("%.0f%%", percentage*100);
        // healthText.textColor = color(
        //         255*(1-percentage),
        //         percentage*255,
        //         0
        // );
    }
    
    public void destroy() {
        Map.setWeight(position, 1);
        // healthText.removeObject();
    }
}