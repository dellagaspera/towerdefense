// NÃO use essa classe, use o objeto "UI"
class UserInterface {

    PImage cannon1 = null;
    PImage cannon2 = null;

    public void setupUI() {
        colorMode(HSB, 360, 100, 100);

        noStroke();

        loadSprites();
    }

    public void settingsUI() {
        size(gridSize*gridX, gridSize*gridY);
        noSmooth();
    }

    private void loadSprites() {
        cannon1 = loadImage("sprites/cannon1.png");
        cannon2 = loadImage("sprites/cannon2.png");
    }

    /**
     * Desenha as coisa na tela
     */
    public void draw() {
        background(0, 0, 0);
        drawStats();
        drawGame();
    }

    private void drawStats() {
        fill(0, 0, 100);
        text("Health: " + health + "\nMoney: " + money, 10, 10);
    }

    private void drawGame() {
        for(Structure s : structures) {
            s.update();
        }
        for(Enemy e : enemies) {
            e.update();
        }
    }

}
