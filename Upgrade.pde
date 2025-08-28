enum Stat { DAMAGE, SHOOTING_SPEED, RANGE, AOE_DAMAGE }

class Upgrade {
    int cost;
    Stat stat;
    float effectF;
    int effectI;
    Upgrade unlocks;

    String name;
    String description;

    public Upgrade(int cost, String name, Stat stat, float effect) {
        this.cost = cost;
        this.name = name;
        this.stat = stat;
        this.effectF = effect;

        switch(stat) {
            case DAMAGE: description = "erro"; break;
            case SHOOTING_SPEED: description = "+" + (effect * 100) + "% velocidade"; break;
            case RANGE: description = "erro"; break;
            case AOE_DAMAGE: description = "erro"; break;
        }
    }

    public Upgrade(int cost, String name, Stat stat, int effect) {
        this.cost = cost;
        this.name = name;
        this.stat = stat;
        this.effectI = effect;

        switch(stat) {
            case DAMAGE: description = "+" + effect + " dano"; break;
            case SHOOTING_SPEED: description = "erro"; break;
            case RANGE: description = "+" + effect + " alcance"; break;
            case AOE_DAMAGE: description = "erro"; break;
        }
    }

    public Upgrade(int cost, String name, Stat stat, float effect, Upgrade unlocks) {
        this.cost = cost;
        this.name = name;
        this.stat = stat;
        this.effectF = effect;
        this.unlocks = unlocks;

        switch(stat) {
            case DAMAGE: description = "erro"; break;
            case SHOOTING_SPEED: description = "+" + (effect * 100) + "% velocidade"; break;
            case RANGE: description = "erro"; break;
            case AOE_DAMAGE: description = "erro"; break;
        }
    }

    public Upgrade(int cost, String name, Stat stat, int effect, Upgrade unlocks) {
        this.cost = cost;
        this.name = name;
        this.stat = stat;
        this.effectI = effect;
        this.unlocks = unlocks;

        switch(stat) {
            case DAMAGE: description = "+" + effect + " dano"; break;
            case SHOOTING_SPEED: description = "erro"; break;
            case RANGE: description = "+" + effect + " alcance"; break;
            case AOE_DAMAGE: description = "erro"; break;
        }
    }
    
    public Upgrade(int cost, String name, Stat stat, int effectI, float effectF) {
        this.cost = cost;
        this.name = name;
        this.stat = stat;
        this.effectI = effectI;
        this.effectF = effectF;

        switch(stat) {
            case DAMAGE: description = "erro"; break;
            case SHOOTING_SPEED: description = "erro"; break;
            case RANGE: description = "erro"; break;
            case AOE_DAMAGE: description = "+" + effectI + " dano em área"; break;
        }
    }
    
    public Upgrade(int cost, String name, Stat stat, int effectI, float effectF, Upgrade unlocks) {
        this.cost = cost;
        this.name = name;
        this.stat = stat;
        this.effectI = effectI;
        this.effectF = effectF;
        this.unlocks = unlocks;

        switch(stat) {
            case DAMAGE: description = "erro"; break;
            case SHOOTING_SPEED: description = "erro"; break;
            case RANGE: description = "erro"; break;
            case AOE_DAMAGE: description = "+" + effectI + " dano em área"; break;
        }
    }
}