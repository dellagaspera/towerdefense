import java.io.File;

class SpriteManager {
    public HashMap<String, PImage> png = new HashMap<>();

    void loadSprites() {
        File folder = new File(sketchPath("assets")); 
        File[] files = folder.listFiles();

        if(files != null) {
            for(File f : files) {
                if(f.isDirectory()) {
                    loadSpritesSubFoder(f.getName());
                } else if (f.isFile() && f.getName().toLowerCase().endsWith(".png")) {
                    String name = f.getName().substring(0, f.getName().lastIndexOf("."));
                    logInfo("LOADING ASSET: `assets/" + f.getName() + "`");
                    png.put(name, loadImage("assets/" + f.getName()));
                }
            }
        } else {
            logError("`assets` folder missing!!!");
        }
    }

    void loadSpritesSubFoder(String folderName) {
        String path = "assets/" + folderName;
        File folder = new File(sketchPath(path)); 
        File[] files = folder.listFiles();

        if (files != null) {
            for (File f : files) {
                if (f.isFile() && f.getName().toLowerCase().endsWith(".png")) {
                    String name = f.getName().substring(0, f.getName().lastIndexOf("."));
                    logInfo("LOADING ASSET: `" + path + "/" + f.getName() + "`");
                    png.put(folderName + "/" + name, loadImage(path + "/" + f.getName()));
                }
            }
        }
    }
}
