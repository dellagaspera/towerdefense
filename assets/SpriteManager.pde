class SpriteManager {
    private String sprite_list[] = null;
    public HashMap<String, PImage> map = new HashMap<>();

    void loadSprites() {
        for(String s : sprite_list) {
            println("LOADING ASSET: `assets/" + s + ".png`");
            map.put(s, loadImage("assets/" + s + ".png"));
        }
    }

    SpriteManager(String[] sprite_list) {
        this.sprite_list = sprite_list;
    }
}