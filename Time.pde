TimeClass Time = new TimeClass();

class TimeClass {
    public float deltaTime = 0;
    public float averageDeltaTime = 0;
    private int lastMillis;
    private float[] pastDeltaTimes = new float[50];
    
    void update() {
        int millis = millis();
        deltaTime = (millis - lastMillis) / 1000.0;
        lastMillis = millis;
        pastDeltaTimes[frameCount % 50] = deltaTime;
        
        if(frameCount % 20 == 0) {
            float sum = 0;
            for(int i = 0; i < 50; i++) {
                sum += pastDeltaTimes[i];
            }
            averageDeltaTime = sum / 50;
        }
    }

    TimeClass() {
        lastMillis = millis();
        for(int i = 0; i < 50; i++) pastDeltaTimes[i] = 0;
    }
}