import java.io.File;

class SpriteManager {
    public HashMap<String, PImage> map = new HashMap<>();

    void loadSprites() {
        File folder = new File(sketchPath("assets")); 
        File[] files = folder.listFiles();

        if (files != null) {
            for (File f : files) {
                if(f.isDirectory()) {
                    loadSpritesSubFoder(f.getName());
                } else if (f.isFile() && f.getName().toLowerCase().endsWith(".png")) {
                    String name = f.getName().substring(0, f.getName().lastIndexOf("."));
                    println("LOADING ASSET: `assets/" + f.getName() + "`");
                    map.put(name, loadImage("assets/" + f.getName()));
                }
            }
        } else {
            println("No files found in assets/");
        }
    }

    void loadSpritesSubFoder(String folderName) {
        String path = "assets/" + folderName;
        File folder = new File(sketchPath(path)); 
        File[] files = folder.listFiles();

        if (files != null) {
            for (File f : files) {
                String name = f.getName().substring(0, f.getName().lastIndexOf("."));
                println("LOADING ASSET: `" + path + "/" + f.getName() + "`");
                map.put(folderName + "/" + name, loadImage(path + "/" + f.getName()));
            }
        } else {
            println("No files found in assets/" + folderName + "/");
        }
    }

    SpriteManager() {
        loadSprites();
    }
}
