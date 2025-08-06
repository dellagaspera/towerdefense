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

        loadFonts();
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
     * Carrega as fontes
     */
    private void loadFonts() {
        DEFAULT_FONT = createFont(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE);
        println("criado");
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
 * Enum responsável pelos tipos de formas da hitbox
 * ou do frame(fundo) dos botões.
 */
public enum ButtonShapes {
    RECTANGLE, CIRCLE
}

/**
 * Classe responsável pelos botões do jogo.
 * Note que essa classe não tem nada visual, apenas
 * uma base para os tipos de botão.
 */
private class Button {

    // Atributos //

    // Forma da Hitbox
    ButtonShapes shape = ButtonShapes.RECTANGLE;
    // Tamanho da área de clique do botão. Para o retângulo,
    // é a largura e a altura. Para o círculo, o primeiro valor
    // será usado para representar o raio.
    PVector hitboxSize = new PVector(30, 30);
    // Posição do vértice superior esquerdo do botão.
    PVector pos;
    // Se o botão está visível ou não.
    // Um botão invisível NÃO é renderizado de nenhuma forma por padrão.
    // Ou seja, nenhuma de suas propriedades são atualizadas se ele estiver
    // invisível (por natureza).
    private boolean visible = true;
    // Se o botão está "interágivel" (se o evento de
    // clicar pode ser executado).
    // Essa propriedade é atualizada sempre que a visibilidade é alterada.
    // Ou seja, por natureza, um botão invisível não pode ser clicado,
    // mas um visível pode.
    private boolean interactable = true;
    // Se o mouse está dentro da área do botão
    private boolean mouseTouching = false;

    // Funções de Evento //

    // Funções que vão ser chamadas quando o respectivo
    // evento acontecer.

    // Quando clicar no botão, essa função será chamada
    public Runnable onClick;
    // Quando o mouse entrar na área do botão, essa função
    // será chamada
    public Runnable onMouseEnter;
    // Quando o mouse sair da área do botão (considerando
    // que ele estava dentro), essa função será chamada
    public Runnable onMouseLeave;

    Button(PVector pos, PVector size) {
        if (buttons == null) {
            buttons = new ArrayList<>();
        }
        this.pos = pos;
        this.hitboxSize = size;

        buttons.add(this);
    }

    // Propriedades //

    // Altera a posição
    public void setPos(PVector newPos) {
        this.pos = newPos;
    }

    // Altera a visibilidade e a interação
    public void setVisibility(boolean newVisibility) {
        this.visible = newVisibility;
        this.interactable = newVisibility;
        if (!newVisibility) {
            mouseTouching = false;
        }
    }

    // Altera a hitbox
    public void setHitboxSize(PVector newHitboxSize) {
        this.hitboxSize = newHitboxSize;
    }

    // Eventos //

    // NÃO ALTERE OS MÉTODOS ABAIXO (que começam com "handle") EM HIPÓTESE ALGUMA!
    // Altere a respectiva função de evento!

    /**
     * Quando o mouse clicar no botão, esse método será chamado.
     * Use a função onClick para customizá-lo.
     */
    private final void handleMousePressed() {
        if (!interactable || !mouseTouching) return; // só executa se puder interagir
        if (onClick != null) onClick.run();
    }

    /**
     * Método chamado quando o mouse entra na área do botão (não
     * necessariamente é clicado, o mouse só toca o botão).
     * Use a função onMouseEnter para customizá-lo.
     */
    private final void handleMouseEnter() {
        //mouseTouching = true;
        if (onMouseEnter != null) onMouseEnter.run();
    }

    /**
     * Método chamado quando o mouse sai da área do botão (o
     * mouse parou de clicar).
     * Use a função onMouseLeave para customizá-lo.
     */
    private void handleMouseLeave() {
        //mouseTouching = false;
        if (onMouseLeave != null) onMouseLeave.run();
    }

    /**
     * Método que verifica se o mouse está tocando o botão.
     */
    private void checkMouseTouching() {
        // Calcula a posição dos vértices das pontas
        PVector upperLeftVertice = new PVector(pos.x, pos.y);
        PVector lowerRightVertice = new PVector(pos.x + hitboxSize.x, pos.y + hitboxSize.y);

        mouseTouching = false;
        // Verifica se tá dentro da área da hitbox
        if (mouseX >= upperLeftVertice.x && mouseX <= lowerRightVertice.x) {
            if (mouseY >= upperLeftVertice.y && mouseY <= lowerRightVertice.y) {
                mouseTouching = true;
            }
        }
        if (mouseTouching) {
            handleMouseEnter();
        } else {
            handleMouseLeave();
        }
    }


    /**
     * Método que será chamado todo frame para atualizar
     * o estado do botão.
     */
    public void update() {
        if (!visible) return; // só atualiza se tiver visível
        handleMousePressed();

        // Verifica se o mouse está fora da tela
        if ( (mouseX <= 0 || mouseX > width) || (mouseY <= 0 || mouseY > height) ) {
            mouseTouching = false;
        } else { // se o mouse está dentro da tela
            checkMouseTouching();
        }

    }

    /**
     * Desenha o botão na tela.
     */
    public void render() {
        // implementado nos filhos
    }

}

/**
 * Botão com um texto customizável.
 */
public class TextButton extends Button {
    private final color DEFAULT_TEXT_COLOR = color(0, 0, 0);
    private final color DEFAULT_BACKGROUND_COLOR = color(255, 255, 255);
    private final int DEFAULT_TEXT_ALIGN = CENTER;
    // Atributos //
        // Texto
    // O texto do botão
    String text;
    // A cor do texto
    color textColor = DEFAULT_TEXT_COLOR;
    // O tamanho do texto
    int textSize = DEFAULT_FONT_SIZE;
    // O alinhamento do texto
    int textAlign = DEFAULT_TEXT_ALIGN; // (LEFT, CENTER OU RIGHT)
    // A fonte do texto
    PFont textFont = DEFAULT_FONT;
        // Fundo
    // A forma do fundo. Use Button.Shape para definir a forma
    // A cor do background
    color backgroundColor = DEFAULT_BACKGROUND_COLOR;

    TextButton(PVector pos, PVector size, String text) {
        super(pos, size);
        this.text = text;
    }
    TextButton(PVector pos, PVector size, String text, color textColor) {
        super(pos, size);
        this.text = text;
        this.textColor = textColor;
    }

    // Propriedades //

    // Alterar o texto
    public void setText(String text) {
        this.text = text;
    }
    // Alterar a cor do texto
    public void setTextColor(color cor) {
        this.textColor = cor;
    }
    // Alterar a fonte
    public void setTextFont(PFont textFont) {
        this.textFont = textFont;
    }
    // Alterar o tamanho do texto
    public void setTextSize(int textSize) {
        this.textSize = textSize;
    }
    // Alterar o alinhamento do texto
    public void setTextAlign(int textAlign) {
        this.textAlign = textAlign;
    }
    // Alterar a cor do fundo
    public void setBackgroundColor(color cor) {
        this.backgroundColor = cor;
    }



    // Eventos //

    /**
     * Desenha o botão na tela.
     */
    @Override
    public void render() {
        // Desenha o fundo
        fill(backgroundColor);
        switch (shape) {
            case RECTANGLE:
                rect(pos.x, pos.y, hitboxSize.x, hitboxSize.y);
                break;
            case CIRCLE:
                // aqui, considera que hitboxSize.x == hitboxSize.y
                circle(pos.x, pos.y, hitboxSize.x);
                break;
        }
        // Desenha o texto
        fill(textColor);
        textFont(textFont);
        textAlign(textAlign, textAlign);
        text(text, pos.x, pos.y, hitboxSize.x, hitboxSize.y);
    }
}

