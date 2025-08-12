static ArrayList<Enemy> enemies = new ArrayList<>();

class Enemy {
    PVector pos = new PVector();
    PVectorInt gridPos = new PVectorInt();

    float moveSpeed = 2;

    
    private PVector[] directions = {new PVector(1, 0), new PVector(-1, 0), new PVector(0, 1), new PVector(0, -1)};

    public MapClass.Node[][] nextNodeGrid = new MapClass.Node[gridX][gridY]; // nextNodeGrid[x][y] = próximo nó a ser visitado pelo inimigo em x,y

    void _update() {
        update();

        render();
    }

    void update() {
        if(Map.nextNodeGrid[gridPos.x][gridPos.y] != null) {
            PVector nextNode = Map.nextNodeGrid[gridPos.x][gridPos.y].pos;
            if(pos.dist(nextNode.copy().mult(tileSize)) < 1) {
                gridPos = new PVectorInt(nextNode);
            }

            pos.add(PVector.sub(nextNode.copy().mult(tileSize), pos).normalize().mult(tileSize * moveSpeed * Time.deltaTime));
        } else calculateBestPath(getNodeFrom(gridPos), getNodeFrom(Map.endPos));
    }


    private MapClass.Node getNodeFrom(PVector pos) {
        try {
            return Map.getPath()[(int) pos.x][(int) pos.y];
        } catch (ArrayIndexOutOfBoundsException e) {
            return null;
        }
    }
    private MapClass.Node getNodeFrom(PVectorInt pos) {
        try {
            return Map.getPath()[pos.x][pos.y];
        } catch (ArrayIndexOutOfBoundsException e) {
            return null;
        }
    }
    
    private boolean isValidPos(PVector pos) {
        return (pos.x >= 0 && pos.x < gridX && pos.y >= 0 && pos.y < gridY);
    }
    
    private float calcularHeuristica(MapClass.Node a, MapClass.Node b) {
        // Distância de Manhattan, já que não é possível andar diagonalmente
        return abs(a.pos.x - b.pos.x) + abs(a.pos.y - b.pos.y);
    }

    private void reconstructPath(MapClass.Node current) {
        // Reconstrói o caminho a partir do nó atual até o nó inicial
        MapClass.Node next;
        while (current.parent != null) {
            next = current;
            current = current.parent;

            // next.image.sprite = sprites.map.get("selectedPath"); // marca o nó como parte do caminho

            nextNodeGrid[(int) current.pos.x][(int) current.pos.y] = next;

        }
        // if (current != null) current.image.sprite = sprites.map.get("selectedPath");
    }

    
    private ArrayList<MapClass.Node> obterVizinhos(MapClass.Node node) {
        ArrayList<MapClass.Node> neighbors = new ArrayList<MapClass.Node>();
        for (PVector direction : directions) {
            PVector neighborPos = PVector.add(node.pos, direction);
            if (isValidPos(neighborPos)) {
                MapClass.Node neighborNode = getNodeFrom(neighborPos);
                if (neighborNode != null) {
                    neighbors.add(neighborNode);
                }
            }
        }
        return neighbors;
    }

    public void calculateBestPath(MapClass.Node start, MapClass.Node end) {
        // Reinicia tudo
        nextNodeGrid = new MapClass.Node[gridX][gridY];

        // Queue de prioridade para os nós a serem visitados.
        // A prioridade é crescente e baseada no valor de f (custo total estimado)
        PriorityQueue<MapClass.Node> openList = new PriorityQueue<MapClass.Node>(
                (a, b) -> Float.compare(a.f, b.f) // compara os valores de f
        );
        openList.add(start);

        // Lista fechada (de nós já visitados).
        // É hashset para buscas rápidas (contains é O(1))
        HashSet<MapClass.Node> closedList = new HashSet<MapClass.Node>();

        // Reinicia o nó inicial (apenas para garantir)
        start.custoDoInicio = 0;
        start.custoParaFim = calcularHeuristica(start, end);
        start.f = start.custoDoInicio + start.custoParaFim;
        start.parent = null;

        while (!openList.isEmpty()) {
            // adiciona o nó inicial à lista aberta
            MapClass.Node nodeAtual = openList.poll(); // pega o nó com menor f

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
            for (MapClass.Node vizinho : obterVizinhos(nodeAtual)) {
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

    
    private PVector getBestNextPos(PVector pos) {
        PVector bestPos = pos.copy();
        float minDist = Float.MAX_VALUE;


        for (int i = 0; i < directions.length; i++) {
            PVector candidate = PVector.add(pos, directions[i]);

            if (isValidPos(candidate) && getNodeFrom(candidate) == null) {
                float dist = PVector.dist(candidate, Map.endPos);
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

        if (random(1) < 0.4 && pos.dist(Map.endPos) > safeDistance) {
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

    
    private void createNode(PVector pos, PVector dir) {
        // Se já existe, não faz nada
        if (getNodeFrom(pos) != null) return;

        // Cria o nó
        MapClass.Node node = Map.new Node(pos);
        Map.getPath()[(int) pos.x][(int) pos.y] = node;

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

        MapClass.Node start = Map.new Node(new PVector(gridPos.x, gridPos.y));
        MapClass.Node end = Map.new Node(Map.endPos);
        createNode(new PVector(gridPos.x, gridPos.y), new PVector(-1, 0));
        createNode(Map.endPos, new PVector(-1, 0));

        ArrayList<MapClass.Node> generatedNodes = new ArrayList<MapClass.Node>();
        for (int i = 0; i < nPath; i++) {
            MapClass.Node curr = start;
            int nNodes = 0;
            do {
                nNodes++;
                PVector newPos;
                // verifica se está na última coluna (se tiver, o objetivo
                // é chegar ao fim)
                if (curr.pos.x == Map.endPos.x) {
                    newPos = new PVector(
                            Map.endPos.x,
                            curr.pos.y + (curr.pos.y > Map.endPos.y ? -1 : 1) // vai em direção ao fim
                    );
                    if (!isValidPos(newPos)) newPos = curr.pos;;
                } else {
                    // se não, pega uma posição aleatória
                    newPos = getNextPos(curr.pos);
                }

                if (newPos.equals(curr.pos) && i != 0) {
                    break; // Sai do laço do-while para este galho
                }

                MapClass.Node temp;
                if (getNodeFrom(newPos) != null) {
                    temp = getNodeFrom(newPos);
                } else {
                    temp = Map.new Node(newPos);
                    createNode(newPos, PVector.sub(newPos, curr.pos));
                    generatedNodes.add(temp);
                }

                curr = temp;

            } while (  (i == 0 && nNodes <= 10*maxPathSize)
                    || (i != 0 && nNodes <= maxPathSize)
                    && !curr.pos.equals(Map.endPos));
            if (!generatedNodes.isEmpty())
                start = generatedNodes.get((int)random(0, generatedNodes.size()));// pra criar um caminho em algum lugar
        }
        // println("Path generated");

        // gera o melhor caminho
        calculateBestPath(getNodeFrom(new PVector(gridPos.x, gridPos.y)), getNodeFrom(Map.endPos));
    }

    void render() {
        fill(255, 80, 80);
        circle(pos.x + 24, pos.y + 24, 24);
    }

    Enemy(PVectorInt gridPos) {
        this.gridPos = gridPos;
        this.pos.set(gridPos.x * tileSize, gridPos.y * tileSize);

        enemies.add(this);
    }
}