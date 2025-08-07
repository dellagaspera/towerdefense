ArrayList<UIObject> UIObjects = new ArrayList<UIObject>();

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
        updateUIObjects();
        //updateButtons(false, false);
        drawStats();
        drawGame();
        drawButtons();
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
        for (Button b : buttons) {
            b.render();
        }
    }

    private void updateUIObjects() {
        for (UIObject uo : UIObjects) {
            uo.update();
        }
    }

    /**
     * Atualiza o estado dos botões
     */
    public void updateButtons(boolean mouseDown, boolean mouseUp) {
        for (Button b : buttons) {
            b.update();
            b.handleMouseInteraction(mouseDown, mouseUp);
        }
    }


}


/**
 * Classe base para objetos da interface.
 *
 * AVISO: Para desenhar um objeto na tela, chame render().
 * No entanto, para customizar a forma que ele é desenhado
 * (ou atualizado a cada frame), customize drawObject().
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
 * Eventos:
 *  * onMouseEnter: função que será executada quando o mouse entrar na
 *  *               area do botão (quando mouseTouching ir de false para true)
 *  * onMouseLeave: função que será executada quando o mouse sair da
 *  *               area do botão (quando mouseTouching ir de true para false)
 *
 */

private abstract class UIObject {

    // Constantes de padrão
    private final Boolean DEFAULT_hasStroke = false;
    private final PVector DEFAULT_size = new PVector(30, 30);
    private final color DEFAULT_strokeColor = color(0, 0, 0);
    private final color DEFAULT_strokeWeight = 16;

    boolean active = true;
    boolean mouseTouching = false;
    PVector pos;
    PVector size = DEFAULT_size;
    PVector hitBoxSize;
    Boolean hasStroke = DEFAULT_hasStroke;
    color strokeColor = DEFAULT_strokeColor;
    float strokeWeight = DEFAULT_strokeWeight;

    // Funções de Evento //

    public Runnable onMouseEnter;
    public Runnable onMouseLeave;

    UIObject (PVector pos, PVector size) {
        this.pos = pos;
        this.size = size;
        this.hitBoxSize = size;
        UIObjects.add(this);
    }

    // NÃO use esse método. Ele literalmente só desenha o
    // objeto na tela, sem se importar com a cor, a borda,
    // etc. O processing não me deixou colocar privado e
    // abstrato. E, sem abstrato, a função render() não
    // atualizava a chamada da função.
    public abstract void drawObject();

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

    public void update() {
        // Verifica se o mouse está fora da tela
        if ( (mouseX <= 0 || mouseX > width-1) || (mouseY <= 0 || mouseY > height-1) ) {
            mouseTouching = false;
            handleMouseLeave();
        } else { // se o mouse está dentro da tela
            checkMouseTouching();
        }
    }

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

    /**
     * Método que verifica se o mouse está tocando o botão.
     */
    private void checkMouseTouching() {
        // Calcula a posição dos vértices das pontas
        PVector upperLeftVertice = new PVector(pos.x, pos.y);
        PVector lowerRightVertice = new PVector(pos.x + hitBoxSize.x, pos.y + hitBoxSize.y);

        boolean lastState = mouseTouching;
        // Verifica se tá dentro da área da hitbox
        if (mouseX >= upperLeftVertice.x && mouseX <= lowerRightVertice.x) {
            if (mouseY >= upperLeftVertice.y && mouseY <= lowerRightVertice.y) {
                if (mouseTouching == false) handleMouseEnter();
                mouseTouching = true;
                return;
            }
        }
        // se chegou até aqui, o mouse não tá na área da hitbox
        mouseTouching = false;
        if (lastState == true && mouseTouching == false) handleMouseLeave();

    }

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
 * sprite: a imagem (se houver)
 * text: o texto (se houver)
 */
public class Frame extends UIObject {

    // Constantes de padrão
    private final color DEFAULT_background_color = color(255, 255, 255);
    private final Shape DEFAULT_shape = Shape.RECTANGLE;

    color backgroundColor = DEFAULT_background_color;
    Shape shape = DEFAULT_shape;
    PImage sprite = null;
    Text text = null;

    // apenas uma forma
    public Frame(PVector pos, PVector size, color backgroundColor, Shape shape) {
        super(pos, size);
        this.size = size;
        this.backgroundColor = backgroundColor;
        this.shape = shape;
    }
    public Frame(PVector pos, PVector size, color backgroundColor, Shape shape, Text text) {
        super(pos, size);
        this.size = size;
        this.backgroundColor = backgroundColor;
        this.shape = shape;
        this.text = text;
    }

    // uma imagem
    public Frame(PVector pos, PVector size, PImage sprite) {
        super(pos, size);
        this.size = size;
        this.sprite = sprite;
    }
    public Frame(PVector pos, PVector size, PImage sprite, Text text) {
        super(pos, size);
        this.size = size;
        this.sprite = sprite;
        this.text = text;
    }

    // uma imagem que, se não for desenhada, aparecerá
    // uma forma com cor definida
    public Frame(PVector pos, PVector size, PImage sprite, color backgroundColor) {
        super(pos, size);
        this.size = size;
        this.sprite = sprite;
        this.backgroundColor = backgroundColor;
    }
    public Frame(PVector pos, PVector size, PImage sprite, color backgroundColor, Text text) {
        super(pos, size);
        this.size = size;
        this.sprite = sprite;
        this.backgroundColor = backgroundColor;
        this.text = text;
    }

    // forma usada quando a posição e o tamanho do frame estão
    // em função de outra coisa
    public Frame(color backgroundColor, Shape shape) {
        super(new PVector(0, 0), new PVector(0, 0));
        this.size = new PVector(0, 0);
        this.backgroundColor = backgroundColor;
        this.shape = shape;
    }
    public Frame(color backgroundColor, Shape shape, Text text) {
        super(new PVector(0, 0), new PVector(0, 0));
        this.size = new PVector(0, 0);
        this.backgroundColor = backgroundColor;
        this.shape = shape;
        this.text = text;
    }

    // imagem usada quando a posição e o tamanho do frame estão
    // em função de outra coisa
    public Frame(PImage sprite) {
        super(new PVector(0, 0), new PVector(0, 0));
        this.size = new PVector(0, 0);
        this.sprite = sprite;
    }
    public Frame(PImage sprite, Text text) {
        super(new PVector(0, 0), new PVector(0, 0));
        this.size = new PVector(0, 0);
        this.sprite = sprite;
        this.text = text;
    }
    public Frame(PImage sprite, color backgroundColor) {
        super(new PVector(0, 0), new PVector(0, 0));
        this.size = new PVector(0, 0);
        this.sprite = sprite;
        this.backgroundColor = backgroundColor;
    }
    public Frame(PImage sprite, color backgroundColor, Text text) {
        super(new PVector(0, 0), new PVector(0, 0));
        this.size = new PVector(0, 0);
        this.sprite = sprite;
        this.backgroundColor = backgroundColor;
        this.text = text;
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
        if (text != null) {
            text.pos = pos;
            text.size = size;
            text.drawObject();
        }
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

    // usado quando a posição e o tamanho do texto estão
    // em função de outra coisa
    public Text(String text) {
        super(new PVector(0, 0), new PVector(50, 50));
        this.text = text;
    }
    public Text(String text, color textColor) {
        super(new PVector(0, 0), new PVector(50, 50));
        this.text = text;
        this.textColor = textColor;
    }
    public Text(String text, color textColor, int textSize, int horizontalTextAlign, int verticalTextAlign) {
        super(new PVector(0, 0), new PVector(50, 50));
        this.text = text;
        this.textColor = textColor;
        this.textSize = textSize;
        this.horizontalTextAlign = horizontalTextAlign;
        this.verticalTextAlign = verticalTextAlign;
    }
    public Text(String text, color textColor, int textSize, int horizontalTextAlign, int verticalTextAlign, PFont textFont) {
        super(new PVector(0, 0), new PVector(50, 50));
        this.text = text;
        this.textColor = textColor;
        this.textSize = textSize;
        this.horizontalTextAlign = horizontalTextAlign;
        this.verticalTextAlign = verticalTextAlign;
        this.textFont = textFont;
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
 *
 * frame: o "desenho" do botão
 * interactable: se é possível clicar no botão ou "entrar na área dele"
 *               ("entrar na área dele" significa que mouseTouching será atualizado)
 * mouseTouching: se o mouse está tocando o botão (ou seja, se o
 *                mouse está dentro da área do botão)
 * mouseDown: se o mouse está sendo pressionado no botão
 *
 * Eventos:
 * onClick: função que será executada quando o botão for clicado
 */
public class Button extends UIObject {

    Frame frame;
    private boolean interactable = true;
    private boolean mouseDown = false;

    // Funções de Evento //

    // Quando clicar no botão, essa função será chamada
    public Runnable onClick;

    Button(PVector pos, PVector size, Frame frame) {
        super(pos, size);
        if (buttons == null) buttons = new ArrayList<>();
        this.frame = frame;

        buttons.add(this);
    }

    /**
     * Método que será chamado todo frame para atualizar
     * o estado do botão.
     */
    //private void update() {
    //    if (!interactable) return; // só atualiza se tiver "interagível"
    //}

    /**
     * Desenha o botão na tela.
     */
    public void drawObject() {
        frame.pos = pos;
        frame.size = size;
        frame.render();
    }


    // NÃO ALTERE OS MÉTODOS ABAIXO (que começam com "handle") EM HIPÓTESE ALGUMA!
    // Altere a respectiva função de evento!

    /**
     * Quando o mouse clicar no botão, esse método será chamado.
     * Use a função onClick para customizá-lo.
     */
    private final void handleMouseInteraction(boolean mouseDown, boolean mouseUp) {
        if (!interactable || !mouseTouching) return; // só executa se puder interagir
        if (mouseDown) handleMouseDown();
        if (mouseUp) handleMouseUp();
    }

    private final void handleMouseDown() {
        mouseOverUI = true;
        mouseDown = true;
    }

    private final void handleMouseUp() {
        mouseOverUI = false;
        if (onClick != null && mouseDown) onClick.run();
        mouseDown = false;
    }

}
