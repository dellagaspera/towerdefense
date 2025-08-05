// NÃO use essa classe, use o objeto "UI"
class __class__UI {

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