class Wall extends Structure {
    static final int weight = 999;
    final float maxHealth = 100;
    float health = maxHealth;
    Text healthText;

    public Wall(PVectorInt position) {
        super(position, sprites.map.get("wall"));
        Map.setWeight(position, weight + (int)health);

        healthText = new Text(
                gridToWorldPosition(position),
                new PVector(tileSize, tileSize),
                "100%"
        );
        healthText.textColor = color(0, 255, 0);
        healthText.fontSize = 16;
    }
    public void attacked(float damage) {
        health -= damage;
        Map.setWeight(position, weight + (int)health);
        if (health <= 0) {
            _destroy();
            return;
        }
    }
    public void update() {
        PVector pos = gridToWorldPosition(position);
        float percentage = health/maxHealth;

        healthText.text = String.format("%.0f%%", percentage*100);
        healthText.textColor = color(
                255*(1-percentage),
                percentage*255,
                0
        );
    }
    public void destroy() {
        Map.setWeight(position, 0);
        healthText.removeObject();
    }
}