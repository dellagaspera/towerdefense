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

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        PVectorInt that = (PVectorInt) o;
        return x == that.x && y == that.y;
    }

    public int hashCode() {
        return 31 * x + y;
    }


    String toString() {
        return "(" + x + "," + y + ")";
    }
}