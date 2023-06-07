PolygonMode polygonMode = new PolygonMode();
GraphMode graphMode = new GraphMode();
boolean drawingPolygons = true;

Polygon currentPolygon;
ArrayList<Polygon> polygons = new ArrayList<Polygon>();
boolean snapping = true;

class PolygonMode {
  void mouseClick() {
    //compute x and y according to pan and zoom
    float x = (targetX - width / 2) / zoom - panX;
    float y = (targetY - height / 2) / zoom - panY;

    currentPolygon.add(new PVector(x, y));
  }

  void keyPress() {
    // if space is pressed, add the current polygon to the list of polygons
    if (key == ' ') {
      int newId = polygons.size();
      while (idAlreadyExists(newId)) newId++;
      currentPolygon.setId(newId);
      polygons.add(currentPolygon);
      currentPolygon = new Polygon();
    }
    // if z is pressed, remove the last point of the current polygon
    else if (key == 'z') {
      if (currentPolygon.size() > 0)
        currentPolygon.remove(currentPolygon.size() - 1);
      else if (polygons.size() > 0) {
        currentPolygon = polygons.get(polygons.size() - 1);
        polygons.remove(polygons.size() - 1);
      }
    } else if (key == 'l') {
      loadFromFile();
    } else if (key == 's') {
      writeToFile();
    } else if (key == 'j') {
      snapping = !snapping;
    }
  }

  void updateTarget() {
    if (snapping && currentPolygon.size() > 0) {
      PVector last = currentPolygon.get(currentPolygon.size() - 1);
      //correct position from zoom and pan
      float lastX = last.x * zoom + width / 2 + panX * zoom;
      float lastY = last.y * zoom + height / 2 + panY * zoom;

      if (abs(mouseX - lastX) < abs(mouseY - lastY)) {
        targetX = lastX;
        targetY = mouseY;
      } else {
        targetY = lastY;
        targetX = mouseX;
      }
    } else {
      targetX = mouseX;
      targetY = mouseY;
    }
  }
}

ArrayList<PVector> vertices = new ArrayList<PVector>();
ArrayList<ArrayList<Integer>> edges = new ArrayList<ArrayList<Integer>>();
//edge edit history
ArrayList<Pair<Integer, Integer>> edgeHistory = new ArrayList<Pair<Integer, Integer>>();


Integer previousVertex = null;

enum GraphInteractionMode {
  Vertex, ConnectedVertex, Edge, SplitEdge
}

GraphInteractionMode graphInteractionMode = GraphInteractionMode.ConnectedVertex;

class GraphMode {
  void mouseClick() {
    switch(graphInteractionMode) {
    case Vertex:
      {
        float x = (targetX - width / 2) / zoom - panX;
        float y = (targetY - height / 2) / zoom - panY;

        vertices.add(new PVector(x, y));
        edges.add(new ArrayList<Integer>());
        previousVertex = vertices.size() - 1;
      }
      break;
    case ConnectedVertex:
      {
        float x = (targetX - width / 2) / zoom - panX;
        float y = (targetY - height / 2) / zoom - panY;

        vertices.add(new PVector(x, y));

        ArrayList<Integer> edge = new ArrayList<Integer>();
        if (previousVertex != null) {
          edge.add(previousVertex);
          edgeHistory.add(new Pair<Integer, Integer>(vertices.size() - 1, previousVertex));
        }
        edges.add(edge);

        previousVertex = vertices.size() - 1;
      }
      break;
    case SplitEdge:
      splitEdgeClosestToMouse();
      break;
    case Edge:
      if (previousVertex == null) {
        previousVertex = getClosestVertex();
      } else {
        int closestVertexIndex = getClosestVertex();
        if (closestVertexIndex != previousVertex) {
          ArrayList<Integer> edge = edges.get(previousVertex);
          edge.add(closestVertexIndex);
          edgeHistory.add(new Pair<Integer, Integer>(previousVertex, closestVertexIndex));
          previousVertex = null;
        }
      }
      break;
    }
  }

  void keyPress() {
    // if space is pressed, add the current polygon to the list of polygons
    if (key == 'v') {
      graphInteractionMode = GraphInteractionMode.Vertex;
    } else if (key == 'b') {
      graphInteractionMode = GraphInteractionMode.ConnectedVertex;
    } else if (key == 'm') {
      graphInteractionMode = GraphInteractionMode.Edge;
    } else if (key == 'n') {
      graphInteractionMode = GraphInteractionMode.SplitEdge;
    } else if (key == 'd') {
      if (previousVertex != null) {
      }
    } else if (key == ' ') {
      previousVertex = null;
    }
    // if z is pressed, remove the last point of the current polygon
    else if (key == 'z') {
      switch(graphInteractionMode) {
      case Vertex:
        if (vertices.size() > 0) {
          if (previousVertex != null && previousVertex == vertices.size() - 1) {
            previousVertex = null;
          }
          vertices.remove(vertices.size() - 1);
          edges.remove(edges.size() - 1);
        }
        break;
      case ConnectedVertex:
        if (vertices.size() > 0) {
          if (previousVertex != null && previousVertex == vertices.size() - 1) {
            previousVertex = null;
          }

          if (edgeHistory.get(edgeHistory.size() - 1).a == vertices.size() - 1) {
            edgeHistory.remove(edgeHistory.size() - 1);
          }
          vertices.remove(vertices.size() - 1);
          edges.remove(edges.size() - 1);
        }
        break;
      case Edge:
        {
          Pair<Integer, Integer> edgeToRemove = edgeHistory.get(edgeHistory.size() - 1);
          edges.get(edgeToRemove.a).remove(edgeToRemove.b);
          edgeHistory.remove(edgeHistory.size() - 1);
        }
        break;
      case SplitEdge:
        if (edgeHistory.size() > 1) {
          if (previousVertex != null && previousVertex == vertices.size() - 1) {
            previousVertex = null;
          }
          if (edgeHistory.get(edgeHistory.size() - 1).a == vertices.size() - 1) {
            Pair<Integer, Integer> edgeToRemove = edgeHistory.get(edgeHistory.size() - 1);
            edges.get(edgeToRemove.a).remove(edgeToRemove.b);
            edgeHistory.remove(edgeHistory.size() - 1);
          }

          if (edgeHistory.get(edgeHistory.size() - 1).b == vertices.size() - 1) {
            Pair<Integer, Integer> edgeToRemove = edgeHistory.get(edgeHistory.size() - 1);
            edges.get(edgeToRemove.a).remove(edgeToRemove.b);
            edgeHistory.remove(edgeHistory.size() - 1);
          }

          vertices.remove(vertices.size() - 1);
          edges.remove(edges.size() - 1);
        }
        break;
      }
    } else if (key == 'l') {
      loadFromFile();
    } else if (key == 's') {
      writeToFile();
    } else if (key == 'j') {
      snapping = !snapping;
    }
  }

  void updateTarget() {
    if (snapping && vertices.size() > 0
      && (graphInteractionMode == GraphInteractionMode.Vertex
      || graphInteractionMode == GraphInteractionMode.ConnectedVertex)) {
      PVector last = vertices.get((previousVertex == null) ? getClosestVertex() : previousVertex);

      //correct position from zoom and pan
      float lastX = last.x * zoom + width / 2 + panX * zoom;
      float lastY = last.y * zoom + height / 2 + panY * zoom;

      if (abs(mouseX - lastX) < abs(mouseY - lastY)) {
        targetX = lastX;
        targetY = mouseY;
      } else {
        targetY = lastY;
        targetX = mouseX;
      }
    } else {
      targetX = mouseX;
      targetY = mouseY;
    }
  }
}

void splitEdgeClosestToMouse() {
  Pair<PVector, Pair<Integer, Integer>> closestEdge = getEdgeClosestToMouse();
  if (closestEdge == null) return;

  PVector closestPoint = closestEdge.a;
  Pair<Integer, Integer> closestVertices = closestEdge.b;

  //add the new vertex
  vertices.add(closestPoint);

  //reconnect the edges by undoing the previous edge and adding two new ones
  ArrayList<Integer> edge = edges.get(closestVertices.a);
  edge.remove(closestVertices.b);
  edge.add(vertices.size() - 1);
  edgeHistory.add(new Pair<Integer, Integer>(closestVertices.a, vertices.size() - 1));

  ArrayList<Integer> newEdge = new ArrayList<Integer>();
  newEdge.add(closestVertices.b);
  edges.add(newEdge);

  edgeHistory.add(new Pair<Integer, Integer>(vertices.size() - 1, closestVertices.b));


  //set previousVertex to the new vertex
  previousVertex = vertices.size() - 1;
}
