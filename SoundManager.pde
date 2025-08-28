import java.io.File;
import processing.sound.*;

class SoundManager {
    public HashMap<String, SoundFile> wav = new HashMap<>();

    private PApplet p;

    void loadSounds() {
        String soundAssetsPath = sketchPath("assets/sounds/");
        File folder = new File(soundAssetsPath); 
        File[] files = folder.listFiles();

        if(files != null) {
            for(File f : files) {
                if(f.isDirectory()) {
                    // loadSoundsSubFoder(f.getName());
                } else if (f.isFile() && f.getName().toLowerCase().endsWith(".wav")) {
                    String name = f.getName().substring(0, f.getName().lastIndexOf("."));
                    logInfo("LOADING ASSET: `assets/sound/" + f.getName() + "`");
                    wav.put(name, new SoundFile(p, soundAssetsPath + f.getName()));
                }
            }
        } else {
            logError("`assets` folder missing!!!");
        }
    }

    void playSound(String sound) {
        SoundFile sf = wav.get(sound);
        if(sf != null) {
            sf.play();
        } else {
            logError("Tried to play non-existing audio file: `" + sound + "`");
        }
    }

    SoundManager(PApplet p) {
        this.p = p;
    }
}
