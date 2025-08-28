import java.util.LinkedList;
import java.util.Queue;

class WaveManager {
    Queue<Wave> waves = new LinkedList<>();
    Wave currentWave;
    public boolean onWave = false;

    void readWaves() {
        String[] lines = loadStrings("waves_data.txt");
        for(String line : lines) {
            line = trim(line);

            Queue<EnemyGroup> groups = new LinkedList<>();

            String[] groupsData = splitTokens(line, ";");

            for(String groupData : groupsData) {
                String[] parts = splitTokens(groupData, ",");

                int health = int(parts[1]);
                int count = int(parts[0]);
                float delay = float(parts[2]);

                groups.add(new EnemyGroup(health, count, delay));
            }

            waves.add(new Wave(groups));
        }
    }

    void startWave() {
        if(waves.size() == 0 || onWave) return;
        onWave = true;
        Wave w = waves.poll();
        currentWave = w;
        w.spawn();
    }
}

class Wave {
    Queue<EnemyGroup> groups = new LinkedList<>();
    public boolean spawning = false;

    void spawn() {
        spawning = true;
        new Thread(() -> spawnWave()).start();
    }

    void spawnWave() {
        try {
            while(groups.size() > 0) {
                EnemyGroup g = groups.peek();
                g.spawn();
                Thread.sleep((g.count + 1) * int(g.delay * 1000));
                groups.poll();
            }
            spawning = false;
        } catch(InterruptedException e) {
            println(e.getMessage());
        }
    }

    public Wave(Queue<EnemyGroup> enemyGroups) {
        for(EnemyGroup e : enemyGroups) {
            groups = new LinkedList<>(enemyGroups);
        }
    }
}

class EnemyGroup {
    int health;
    int count;
    float delay;

    public void spawn() {
        new Thread(() -> spawnGroup()).start();
    }

    public void spawnGroup() {
        try {
            for(int i = 0; i < count; i++) {
                new Enemy(spawners[(int)random(0, nSpawner)], health);
                Thread.sleep(int(delay * 1000));
            }
            Thread.sleep(int(delay * 1000));
        } catch(InterruptedException e) {
            println(e.getMessage());
        }
    }

    public EnemyGroup(int health, int count, float delay) {
        this.health = health;
        this.count = count;
        this.delay = delay;
    }
}