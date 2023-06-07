

//write polygons and graph to file
void writeToFile() {
  try {
  PrintWriter output = createWriter("resources/" + filename + ".txt");
  for (int i = 0; i < polygons.size(); i++) {
    ArrayList<PVector> polygon = polygons.get(i);
    //print polygon name
    output.print(polygons.get(i).label + ":" + polygons.get(i).id + ":");
    for (int j = 0; j < polygon.size(); j++) {
      PVector vector = polygon.get(j);
      int vx = (int) (vector.x + toAnnotate.width/2);
      int vy = (int) (vector.y + toAnnotate.height/2);
      output.print(vx + " " + vy);
      if (j != polygon.size() - 1) output.print(";");
    }
    output.println();
  }
  output.flush();
  output.close();


  /*
  <v1 x>,<v1 y>
  <v2 x>,<v2 y>
  ...
  -------
  v1: <v..>,<v..>,..
  v2: <v..>,<v..>,..
  ...

  (first a list containing the coordinates of the vertices is given. After this list of vertices coordinates, you get for each vertex, the index of the vertices that it is connected to.
  */

  PrintWriter output2 = createWriter("resources/" + filename + "_graph.txt");

  //convert direction to undirected graph
  ArrayList<ArrayList<Integer>> undirectedEdges = new ArrayList<ArrayList<Integer>>();
  for (int i = 0; i < edges.size(); i++) {
    ArrayList<Integer> edge = edges.get(i);
    undirectedEdges.add(new ArrayList<Integer>());
  }

  for (int i = 0; i < edges.size(); i++) {
    ArrayList<Integer> edge = edges.get(i);
    for (int j = 0; j < edge.size(); j++) {
        //add i to edge.get(j) and edge.get(j) to i
        undirectedEdges.get(i).add(edge.get(j));
        undirectedEdges.get(edge.get(j)).add(i);
    }
  }

  for (int i = 0; i < vertices.size(); i++) {
    PVector vertex = vertices.get(i);
    int vx = (int) (vertex.x + toAnnotate.width/2);
    int vy = (int) (vertex.y + toAnnotate.height/2);
    output2.println(vx + "," + vy);
  }

  output2.println("-------");

  for (int i = 0; i < edges.size(); i++) {
    ArrayList<Integer> edge = undirectedEdges.get(i);
    output2.print(i + ":");
    for (int j = 0; j < edge.size(); j++) {
      int vertex = edge.get(j);
      output2.print(vertex);
      if (j != edge.size() - 1) output2.print(",");
    }
    output2.println();
  }

  output2.flush();
  output2.close();
  } catch (Exception e) {
    e.printStackTrace();
  }
}

void loadFromFile() {
  String[] lines = loadStrings("resources/" + filename + ".txt");
  polygons = new ArrayList<Polygon>();
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i];
    String[] data = line.split(":");
    String[] points = split(data[2], ";");
    Polygon polygon = new Polygon(data[0], Integer.valueOf(data[1]));
    for (int j = 0; j < points.length; j++) {
      String point = points[j];
      String[] coords = split(point, " ");
      int x = Integer.parseInt(coords[0]) - toAnnotate.width/2;
      int y = Integer.parseInt(coords[1]) - toAnnotate.height/2;
      polygon.add(new PVector(x, y));
    }
    polygons.add(polygon);
  }

  String[] lines2 = loadStrings("resources/" + filename + "_graph.txt");
  vertices = new ArrayList<PVector>();
  edges = new ArrayList<ArrayList<Integer>>();
  boolean readingVertices = true;
  for (int i = 0; i < lines2.length; i++) {
    if (readingVertices) {
      String line = lines2[i];
      if (line.equals("-------")) {
        readingVertices = false;
        continue;
      }
      String[] coords = split(line, ",");
      int x = Integer.parseInt(coords[0]) - toAnnotate.width/2;
      int y = Integer.parseInt(coords[1]) - toAnnotate.height/2;
      vertices.add(new PVector(x, y));
      edges.add(new ArrayList<Integer>());
    } else {
      String line = lines2[i];
      String[] data = split(line, ":");
      int vertex = Integer.parseInt(data[0]);
      String[] connectedVertices = split(data[1], ",");
      for (int j = 0; j < connectedVertices.length; j++) {
        if (!connectedVertices[j].isEmpty()) {
          int connectedVertex = Integer.parseInt(connectedVertices[j]);
          if (connectedVertex > vertex)
            edges.get(vertex).add(connectedVertex);
        }
      }
    }
  }
}
