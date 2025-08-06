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
       // noSmooth();
    }

    private void loadFonts() {
        DEFAULT_TEXT_FONT = createFont(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE);
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


/**
 * Classe base para objetos da interface.
 *
 * active: se o objeto está ativo (ou seja, vai ser renderizado
 *         e atualizado).
 * pos: a posição do objeto na tela.
 *  -> Para retângulos: a posição do vértice superior esquerdo
 *  -> Para círculos: a posição do centro
 * size: tamanho da forma
 *  -> Para retângulos: (largura, altura)
 *  -> Para círculos: (raio, "tanto faz o que estiver aqui")
 * hitBoxSize: a largura e a altura da hitbox do objeto
 * hasStroke: se tem borda
 * strokeColor: a cor da borda (se tiver)
 * strokeWeight: a largura da borda (se tiver)
 *
 * Para desenhar um objeto na tela, chame render().
 * No entanto, para customizar a forma que ele é desenhado,
 * customize drawObject().
 */
private abstract class UIObject {

    // Constantes de padrão
    private final Boolean DEFAULT_hasStroke = false;
    private final PVector DEFAULT_size = new PVector(30, 30);
    private final color DEFAULT_strokeColor = color(0, 0, 0);
    private final color DEFAULT_strokeWeight = 16;

    boolean active = true;
    PVector pos;
    PVector size = DEFAULT_size;
    PVector hitBoxSize;
    Boolean hasStroke = DEFAULT_hasStroke;
    color strokeColor = DEFAULT_strokeColor;
    float strokeWeight = DEFAULT_strokeWeight;

    UIObject (PVector pos, PVector size) {
        this.pos = pos;
        this.size = size;
        this.hitBoxSize = size;
    }

    // NÃO use esse método. Ele literalmente só desenha o
    // objeto na tela, sem se importar com a cor, a borda,
    // etc. O processing não me deixou colocar privado e
    // abstrato. E, sem abstrato, a função render() não
    // atualizava a chamada da função.
    public abstract void drawObject();

    // Método que prepara para desenhar o objeto na tela
    // e desenha ele na tela
    public void render() {
        if (!active) return;
        if (hasStroke) {
            stroke(strokeColor);
            strokeWeight(strokeWeight);
        } else {
            noStroke();
        }
        drawObject();
    };

}

/**
 * Enum responsável pelos tipos de formas.
 */
public enum Shape {
    RECTANGLE, CIRCLE
}


/**
 * Classe que representa uma forma geométrica (definidas
 * pelo enum Shapes)
 *
 * backgroundColor: cor da forma
 * shape: tipo de forma
 */
public class Frame extends UIObject {

    // Constantes de padrão
    private final color DEFAULT_background_color = color(255, 255, 255);
    private final Shape DEFAULT_shape = Shape.RECTANGLE;

    color backgroundColor = DEFAULT_background_color;
    Shape shape = DEFAULT_shape;
    PImage sprite = null;

    // apenas uma forma
    public Frame(PVector pos, PVector size, color backgroundColor, Shape shape) {
        super(pos, size);
        this.size = size;
        this.backgroundColor = backgroundColor;
        this.shape = shape;
    }

    // uma imagem
    public Frame(PVector pos, PVector size, PImage sprite) {
        super(pos, size);
        this.size = size;
        this.sprite = sprite;
    }

    // uma imagem que, se não for desenhada, aparecerá
    // uma forma com cor definida
    public Frame(PVector pos, PVector size, PImage sprite, color backgroundColor) {
        super(pos, size);
        this.size = size;
        this.sprite = sprite;
        this.backgroundColor = backgroundColor;
    }

    // forma usada quando a posição e o tamanho do frame estão
    // em função de outra coisa
    public Frame(color backgroundColor, Shape shape) {
        super(new PVector(0, 0), new PVector(0, 0));
        this.size = new PVector(0, 0);
        this.backgroundColor = backgroundColor;
        this.shape = shape;
    }

    // imagem usada quando a posição e o tamanho do frame estão
    // em função de outra coisa
    public Frame(PImage sprite) {
        super(new PVector(0, 0), new PVector(0, 0));
        this.size = new PVector(0, 0);
        this.sprite = sprite;
    }
    public Frame(PImage sprite, color backgroundColor) {
        super(new PVector(0, 0), new PVector(0, 0));
        this.size = new PVector(0, 0);
        this.sprite = sprite;
        this.backgroundColor = backgroundColor;
    }


    // Desenha o frame na tela
    public void drawObject() {
        fill(backgroundColor);
        switch (shape) {
            case RECTANGLE:
                rect(pos.x, pos.y, size.x, size.y);
                break;
            case CIRCLE:
                circle(pos.x, pos.y, size.x);
                break;
            default:
                throw new IllegalArgumentException("Class Frame does not support shape " + shape);
        }

        // desenha a imagem se houver
        if (sprite != null) image(sprite, pos.x, pos.y, size.x, size.y);
    }

}

/**
 * Classe que representa um texto.
 *
 * text: o texto
 * textColor: a cor do texto
 * textSize: o tamanho do texto
 * textAlign: o alinhamento do texto
 * textFont: a fonte do texto
 *
 * backgroundFrame: o frame que fica de fundo (se for null, não aparece nada)
 *
 */
public class Text extends UIObject {

    // Constantes de padrão
    private final color DEFAULT_text_color = color(0, 0, 0);
    private final int DEFAULT_horizontal_text_align = CENTER;
    private final int DEFAULT_vertical_text_align = CENTER;

    String text;
    color textColor = DEFAULT_text_color;
    int textSize = DEFAULT_FONT_SIZE;
    int horizontalTextAlign = DEFAULT_horizontal_text_align; // (LEFT, CENTER OU RIGHT)
    int verticalTextAlign = DEFAULT_vertical_text_align; // (TOP, CENTER OU BOTTOM)
    PFont textFont = DEFAULT_TEXT_FONT;

    Frame backgroundFrame = null;

    // sem frame
    public Text(PVector pos, PVector size, String text) {
        super(pos, size);
        this.text = text;
    }

    // com frame
    public Text(PVector pos, PVector size, String text, Frame backgroundFrame) {
        super(pos, size);
        this.text = text;
        this.backgroundFrame = backgroundFrame;
    }

    public void drawObject() {
        if (backgroundFrame != null) {
            backgroundFrame.pos = pos;
            backgroundFrame.size = size;
            backgroundFrame.render();
        }
        fill(textColor);
        textSize(textSize);
        if (textFont != null) {
            textFont(textFont);
        } else {
            println("a fonte do texto \"" + text + "\" nao foi carregada");
        }

        textAlign(horizontalTextAlign, verticalTextAlign);
        text(text, pos.x, pos.y, size.x, size.y);
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

    // Forma da Hitbox
    Shape shape = Shape.RECTANGLE;
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
