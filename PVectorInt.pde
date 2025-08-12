class PVectorInt {
    int x = 0;
    int y = 0;

    PVectorInt(int x, int y)  {
        this.x = x;
        this.y = y;
    }

    PVectorInt(float x, float y)  {
        this.x = (int)x;
        this.y = (int)y;
    }
    PVectorInt(PVector vector)  {
        this.x = (int)vector.x;
        this.y = (int)vector.y;
    }

    PVectorInt() {};

    String toString() {
        return "(" + x + "," + y + ")";
    }
}