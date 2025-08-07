void mousePressed() {
    UI.updateButtons(true, false);
}

void mouseReleased() {
    UI.updateButtons(false, true);
    build();
}

void keyPressed() {
    if(key == 'e') {
        new Enemy(new PVector(mouseX, mouseY));
    }
}

void build() {
    int x = mouseX / gridSize;
    int y = mouseY / gridSize;

    if(x < 0 || x >= gridX - 1 || y < 0 || y >= gridY - 1) return;

    money -= 100;

    new Cannon(x, y);
}