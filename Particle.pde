ArrayList<Particle> particles = new ArrayList<>();
ArrayList<Particle> deadParticles = new ArrayList<>();
HashMap<String, Particle> particlePresets = new HashMap<>();

class Particle {

    PImage sprites[] = new PImage[0];
    PImage sprite = null;
    PVector pos = new PVector(0, 0);
    PVector size = new PVector(0, 0);
    // PVector vel = new PVector(0, 0);
    float lifeTime = 0;
    float duration = 1;

    void _update() {
        lifeTime += Time.deltaTime;

        if(sprites.length <= 0 || lifeTime >= duration) {
            die();
            return;
        }

        sprite = sprites[int((lifeTime / duration) * sprites.length)];

        update();

        render();
    }

    void update() {
        
    }

    void render() {
        image(sprite, pos.x, pos.y, size.x, size.y);
    }

    void die() {
        deadParticles.add(this);
        // particles.remove(this);
    }

    void spawn(PVector pos) {
        new Particle(sprites, pos, size, duration);
    }

    public Particle(PImage[] sprites, PVector pos, PVector size, float duration) {
        this.sprites = sprites;
        this.pos = pos;
        this.size = size;
        // this.vel = vel;
        this.duration = duration;

        particles.add(this);
    }

    public Particle(PImage[] sprites, PVector size, float duration) { // preset
        this.sprites = sprites;
        this.size = size;
        this.duration = duration;
    }
}