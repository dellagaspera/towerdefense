class Sand extends Structure {
    static final int weight = 2;

    public Sand(PVectorInt position) {
        super(position, sprites.png.get("sand"), false);
        Map.setWeight(position, weight);
    }
}