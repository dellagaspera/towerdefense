// NÃO use essa classe, use o objeto "UI"
class UserInterface {

    PImage cannon1 = null;
    PImage cannon2 = null;

    /**
     * Inicializa a interface
     */
    public void setupUI() {
        colorMode(HSB, 360, 100, 100);

        noStroke();

        loadSprites();
    }

    /**
     * Define o tamanho da tela
     */
    public void settingsUI() {
        size(gridSize*gridX, gridSize*gridY);
        noSmooth();
    }

    /**
     * Carrega as imagens
     */
    private void loadSprites() {
        cannon1 = loadImage("sprites/cannon1.png");
        cannon2 = loadImage("sprites/cannon2.png");
    }

    /**
     * Desenha as coisa na tela
     */
    public void draw() {
        background(0, 0, 0);
        drawStats();
        drawGame();
    }

    /**
     * Desenha os dados do jogador/jogo
     */
    private void drawStats() {
        fill(0, 0, 100);
        text("Health: " + health + "\nMoney: " + money, 10, 10);
    }

    /**
     * Desenha os elementos do jogo
     */
    private void drawGame() {
        for(Structure s : structures) {
            s.render();
        }
        for(Enemy e : enemies) {
            e.render();
        }
    }

    /**
     * Desenha os botões do jogo
     */
    public void drawButtons() {

    }


}

ArrayList<Button> buttons = new ArrayList<>();

/**
 * Classe responsável pelos botões do jogo.
 * Note que essa classe não tem nada visual, apenas
 * uma base para os tipos de botão.
 */
private class Button {
    // Atributos //

    // Posição do Botão
    PVector pos;
    // Se o botão está visível ou não
    boolean visible = true;
    // Se o botão está "interágivel" (se a função mousePressed
    // vai ser executada)
    boolean interactable = true;
    // Se o mouse está dentro da área do botão
    boolean mouseTouching = false;

    // Funções de Evento //

    //
    public Runnable onClick;
    public Runnable onMouseEnter;
    public Runnable onMouseLeave;

    Button(PVector pos) {
        this.pos = pos;

        buttons.add(this);
    }

    /**
     * Quando o mouse clicar no botão, essa função será chamada
     * após as atualizações do botão.
     */
    private void action() {
        // ...
    }

    /**
     * Quando o mouse clicar no botão, esse método será chamado.
     * NÃO ALTERE ELE! Ele foi feito para outras características
     * do botão também!
     * Use o método "action" para definir a função do botão.
     */
    private final void mousePressed() {
        if (!interactable) return; // só executa se puder interagir
        action();
    }

    private void mouseEnter

    /**
     * Método chamado quando o mouse entra na área do botão (não
     * necessariamente clica, o mouse só toca o botão)
     */
    private void mouseEnter() {

    }

    /**
     * Método chamado quando o mouse sai da área do botão (o
     * mouse parou de clicar)
     */
    private void mouseLeave() {

    }

    /**
     * Desenha o botão na tela.
     */
    public void render() {
        // implementado nos filhos
    }

}

public class ImageButton extends Button {

}