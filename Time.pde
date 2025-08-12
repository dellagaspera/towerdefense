TimeClass Time = new TimeClass();

class TimeClass {
    public float deltaTime = 0;
    private int lastMillis;
    
    void update() {
        int millis = millis();
        deltaTime = (millis - lastMillis) / 1000.0;
        lastMillis = millis;
    }

    TimeClass() {
        lastMillis = millis();
    }
}