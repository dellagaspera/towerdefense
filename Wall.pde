class Wall extends Structure {
    public Wall(PVectorInt position) {
        super(position, sprites.map.get("path"));
        Map.setWeight(position, 999);
    }
}