import java.util.PriorityQueue; // heap queue (para implementar o min-heap)
import java.util.HashSet; // otimização para a lista fechada (já visitados)

MapClass Map = new MapClass();

private class MapClass {

    private final PVector startPos = new PVector(gridX-1, gridY/2);
    private final PVector endPos = new PVector(0, gridY/2);

    private PVector[] directions = {new PVector(1, 0), new PVector(-1, 0), new PVector(0, 1), new PVector(0, -1)};

    private Node[][] path = new Node[gridX][gridY];
    public Node[][] nextNodeGrid = new Node[gridX][gridY]; // nextNodeGrid[x][y] = próximo nó a ser visitado pelo inimigo em x,y


    MapClass() {

    }

    public class Node {
        PVector pos;
        int id, custo = 1;
        float f, custoDoInicio, custoParaFim;
        Node parent; // nó pai (usado para reconstruir o caminho no a*)

        public Node(PVector pos) {
            this.pos = pos;
            this.id = (int) pos.x + (int) pos.y * gridX; // id é a posição linear no grid
        }
        public Node(PVector pos, Node parent, float costFromStart, float costToEnd) {
            this.pos = pos;
            this.id = (int) pos.x + (int) pos.y * gridX; // id é a posição linear no grid
            this.custoDoInicio = costFromStart;
            this.custoParaFim = costToEnd;
            this.f = costFromStart + costToEnd;
            this.parent = parent;
        }
    }

    public void setWeight(PVector pos, int weight) {
        setWeight(new PVectorInt(pos), weight);
    }
    public void setWeight(PVectorInt pos, int weight) {
        Node node = getNodeFrom(pos);
        if (node != null) {
            node.custo = weight;
            // atualiza o caminho
            calculateBestPath(getNodeFrom(startPos), getNodeFrom(endPos));
        } else {
            //println("null!");
        }
    }

    public PVector getNextPositionFrom(PVector pos) {
        if (!isValidPos(pos)) return null; // posição inválida


        Node currentNode = getNodeFrom(pos);
        if (currentNode == null) return null; // não há nó na posição


        // se o próximo nó já foi calculado, retorna a posição dele
        Node nextNode = nextNodeGrid[(int) pos.x][(int) pos.y];
        if (nextNode != null) return nextNode.pos;


        // se não, calcula o próximo nó usando A*
        calculateBestPath(getNodeFrom(startPos), getNodeFrom(endPos));
        nextNode = nextNodeGrid[(int) pos.x][(int) pos.y];
        return nextNode != null ? nextNode.pos : null;
    }

    private boolean isValidPos(PVector pos) {
        return (pos.x >= 0 && pos.x < gridX && pos.y >= 0 && pos.y < gridY);
    }

    private Node getNodeFrom(PVector pos) {
        try {
            return path[(int) pos.x][(int) pos.y];
        } catch (ArrayIndexOutOfBoundsException e) {
            return null;
        }
    }
    private Node getNodeFrom(PVectorInt pos) {
        try {
            return path[pos.x][pos.y];
        } catch (ArrayIndexOutOfBoundsException e) {
            return null;
        }
    }

    private PVector getBestNextPos(PVector pos) {
        PVector bestPos = pos.copy();
        float minDist = Float.MAX_VALUE;


        for (int i = 0; i < directions.length; i++) {
            PVector candidate = PVector.add(pos, directions[i]);

            if (isValidPos(candidate) && getNodeFrom(candidate) == null) {
                float dist = PVector.dist(candidate, endPos);
                if (dist < minDist) {
                    minDist = dist;
                    bestPos = candidate;
                }
            }
        }
        return bestPos;
    }

    private PVector getNextPos(PVector pos) {
        PVector nextPos = getBestNextPos(pos);

        // distância segura até o final
        float safeDistance = 5;

        if (random(1) < 0.4 && pos.dist(endPos) > safeDistance) {
            int tries = 0;
            boolean valid;
            do {
                if (tries > 50) return nextPos;
                tries++;
                nextPos = PVector.add(pos, directions[(int) random(0, 4)]);
                valid = isValidPos(nextPos);
                 if (valid) {
                     // valid = (getNodeFrom(nextPos) == null);
                     valid = (nextPos.x < gridX - 1);
                 }


            } while (!valid);
        }

        return nextPos;
    }

    // para debugar se precisar
    private void printPath() {
        println("=========================================");
        for (int j = 0; j < gridY; j++) {
            for (int k = 0; k < gridX; k++) {
                if (path[k][j] != null) {
                    print("1");
                } else {
                    print(".");
                }
            }
            println();
        }
        println("=========================================\n");
    }

    private void createNode(PVector pos, PVector dir) {
        // Se já existe, não faz nada
        if (getNodeFrom(pos) != null) return;

        // Cria o nó
        Node node = new Node(pos);
        path[(int) pos.x][(int) pos.y] = node;

        // Cria a imagem
        // node.image = new Image(
        //         PVector.mult(pos, tileSize),
        //         new PVector(tileSize, tileSize),
        //         sprites.map.get("path")
        // ){
        //     void onClick() { clickingOnPath = true; }
        // };
        // node.image.setPriority(1);
        // node.image.nineSlice = false;

    }

    public void generatePath() {

        Node start = new Node(startPos);
        Node end = new Node(endPos);
        createNode(startPos, new PVector(-1, 0));
        createNode(endPos, new PVector(-1, 0));

        ArrayList<Node> generatedNodes = new ArrayList<Node>();
        for (int i = 0; i < nPath; i++) {
            Node curr = start;
            int nNodes = 0;
            do {
                nNodes++;
                PVector newPos;
                // verifica se está na última coluna (se tiver, o objetivo
                // é chegar ao fim)
                if (curr.pos.x == endPos.x) {
                    newPos = new PVector(
                            endPos.x,
                            curr.pos.y + (curr.pos.y > endPos.y ? -1 : 1) // vai em direção ao fim
                    );
                    if (!isValidPos(newPos)) newPos = curr.pos;;
                } else {
                    // se não, pega uma posição aleatória
                    newPos = getNextPos(curr.pos);
                }

                if (newPos.equals(curr.pos) && i != 0) {
                    break; // Sai do laço do-while para este galho
                }

                Node temp;
                if (getNodeFrom(newPos) != null) {
                    temp = getNodeFrom(newPos);
                } else {
                    temp = new Node(newPos);
                    createNode(newPos, PVector.sub(newPos, curr.pos));
                    generatedNodes.add(temp);
                }

                curr = temp;

            } while (  (i == 0 && nNodes <= 10*maxPathSize)
                    || (i != 0 && nNodes <= maxPathSize)
                    && !curr.pos.equals(endPos));
            if (!generatedNodes.isEmpty())
                start = generatedNodes.get((int)random(0, generatedNodes.size()));// pra criar um caminho em algum lugar
        }
        // println("Path generated");

        // gera o melhor caminho
        calculateBestPath(getNodeFrom(startPos), getNodeFrom(endPos));
    }


    // Implementação do A* //

    /**
     * Calcula a heurística entre dois nós.
     * A heurística é a estimativa de custo para chegar do nó 'a' ao nó 'b'.
     * @param a Nó de partida.
     * @param b Nó de destino.
     * @return float representando a distância heurística entre os nós.
     */
    private float calcularHeuristica(Node a, Node b) {
        // Distância de Manhattan, já que não é possível andar diagonalmente
        return abs(a.pos.x - b.pos.x) + abs(a.pos.y - b.pos.y);
    }

    /**
     * Retorna os vizinhos de um nó no grid.
     * @param node Nó do grid para o qual se deseja encontrar os vizinhos.
     * @return ArrayList<Node> com os vizinhos do nó.
     */
    private ArrayList<Node> obterVizinhos(Node node) {
        ArrayList<Node> neighbors = new ArrayList<Node>();
        for (PVector direction : directions) {
            PVector neighborPos = PVector.add(node.pos, direction);
            if (isValidPos(neighborPos)) {
                Node neighborNode = getNodeFrom(neighborPos);
                if (neighborNode != null) {
                    neighbors.add(neighborNode);
                }
            }
        }
        return neighbors;
    }

    /**
     * Reconstrói o caminho a partir do nó atual até o nó inicial.
     * @param current Nó do qual se deseja reconstruir o caminho a partir de.
     */
    private void reconstructPath(Node current) {
        // Reconstrói o caminho a partir do nó atual até o nó inicial
        Node next;
        while (current.parent != null) {
            next = current;
            current = current.parent;

            // next.image.sprite = sprites.map.get("selectedPath"); // marca o nó como parte do caminho

            nextNodeGrid[(int) current.pos.x][(int) current.pos.y] = next;

        }
        // if (current != null) current.image.sprite = sprites.map.get("selectedPath");
    }

    /**
     * Calcula o próximo nó a ser visitado por cada nó do grid usando A*.
     * Isso é usado para determinar a direção que os inimigos devem seguir.
     */
    public void calculateBestPath(Node start, Node end) {
        // Reinicia tudo
        nextNodeGrid = new Node[gridX][gridY];

        // Reinicia as cores
        for (int i = 0; i < gridX; i++) {
            for (int j = 0; j < gridY; j++) {
                Node node = path[i][j];
                if (node != null) {
                    // node.image.sprite = sprites.map.get("path");
                }
            }
        }

        // Queue de prioridade para os nós a serem visitados.
        // A prioridade é crescente e baseada no valor de f (custo total estimado)
        PriorityQueue<Node> openList = new PriorityQueue<Node>(
                (a, b) -> Float.compare(a.f, b.f) // compara os valores de f
        );
        openList.add(start);

        // Lista fechada (de nós já visitados).
        // É hashset para buscas rápidas (contains é O(1))
        HashSet<Node> closedList = new HashSet<Node>();

        // Reinicia o nó inicial (apenas para garantir)
        start.custoDoInicio = 0;
        start.custoParaFim = calcularHeuristica(start, end);
        start.f = start.custoDoInicio + start.custoParaFim;
        start.parent = null;

        while (!openList.isEmpty()) {
            // adiciona o nó inicial à lista aberta
            Node nodeAtual = openList.poll(); // pega o nó com menor f

            // verifica se já foi visitado
            if (closedList.contains(nodeAtual)) continue;

            // verifica se não é o nó final
            if (nodeAtual.pos.equals(end.pos)) {
                // se o nó atual é o nó final, reconstrói o caminho
                reconstructPath(nodeAtual);
                return;
            }

            // marca como visitado
            closedList.add(nodeAtual);

            // explora os vizinhos
            for (Node vizinho : obterVizinhos(nodeAtual)) {
                // verifica se já foi visitado
                if (closedList.contains(vizinho)) continue;

                // calcula o custo do caminho do início até o vizinho
                float novoCustoDoInicio = nodeAtual.custoDoInicio + vizinho.custo;

                if (!openList.contains(vizinho)) {
                    // se o vizinho não está na lista aberta, adiciona ele

                    vizinho.custoDoInicio = novoCustoDoInicio;
                    vizinho.custoParaFim = calcularHeuristica(vizinho, end);
                    vizinho.parent = nodeAtual;
                    vizinho.f = vizinho.custoDoInicio + vizinho.custoParaFim;
                    openList.add(vizinho);
                } else if (novoCustoDoInicio < vizinho.custoDoInicio) {
                    // se o custo do caminho atual é menor que o custo já registrado

                    vizinho.custoDoInicio = novoCustoDoInicio;
                    /* não precisa dessa linha, pois a heurística já foi calculada)
                    vizinho.custoParaFim = calculateHeuristic(vizinho, end); */
                    vizinho.f = vizinho.custoDoInicio + vizinho.custoParaFim;
                    vizinho.parent = nodeAtual;
                    openList.add(vizinho); // re-adiciona para atualizar a prioridade
                }

            }


        }

        // se chegou até aqui, não encontrou um caminho
        // o código NUNCA deveria chegar aqui, pois sempre há um caminho
        // println("Não foi possível encontrar um caminho do início ao fim.");
        generatePath(); // gera o caminho dnv
    }

    public Node[][] getPath() {
        return path;
    }
}