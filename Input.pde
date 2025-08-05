void mouseReleased() {
    build();
}

void keyPressed() {
    if(key == 'e') {
        new Enemy(new PVector(mouseX, mouseY));
    }
}