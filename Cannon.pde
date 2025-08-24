class Cannon extends Tower {

    public Cannon(PVectorInt position) {
        super(position, sprites.png.get("cannon"), 1, 2.5f);
        this.damage = damage;
        this.reloadDuration = reloadDuration;
        this.range = 2;

        sellPrice = buildCosts.prices.get("Cannon") * 3/4;

        upgrades[0] = 
            new Upgrade(300, "Tiro Reforçado", Stat.DAMAGE, 1,
            new Upgrade(600, "Chumbo", Stat.DAMAGE, 1,
            new Upgrade(750, "Tiro de Titânio", Stat.DAMAGE, 1)));
        upgrades[1] = 
            new Upgrade(400, "Aceleração", Stat.SHOOTING_SPEED, 0.2,
            new Upgrade(800, "Turbo", Stat.SHOOTING_SPEED, 0.3,
            new Upgrade(1500, "Metralhadora", Stat.SHOOTING_SPEED, 0.5)));
        upgrades[2] = 
            new Upgrade(500, "Luneta", Stat.RANGE, 1,
            new Upgrade(750, "Mira Laser", Stat.RANGE, 1,
            new Upgrade(1500, "Visão Noturna", Stat.RANGE, 2)));
    }
}