
//draw the polygons
void drawPolygons() {
  for (Polygon polygon : polygons) {
    polygon.show();
  }
}

//draw current polygon with red
void drawCurrentPolygon() {
  stroke(255, 0, 0);
  fill(0, 140, 140, 100);
  beginShape();
  for (PVector vector : currentPolygon) {
    vertex(vector.x, vector.y);
  }
  endShape(CLOSE);
}

//draw a line from last point to mouse
void drawLineToMouse() {
  stroke(255, 0, 0);

  //correct last point for pan and zoom
  if (currentPolygon.size() > 0) {
    PVector lastPoint = currentPolygon.get(currentPolygon.size() - 1);
    float lastX = lastPoint.x * zoom + width/2 + panX * zoom;
    float lastY = lastPoint.y * zoom + height/2 + panY * zoom;
    line(lastX, lastY, targetX, targetY);
  }
}

void drawGraph() {
  strokeWeight(2);
  for (PVector vertex : vertices) {
    stroke(0, 100, 230);
    fill(70, 50, 180, 100);
    ellipse(vertex.x, vertex.y, 10, 10);
  }

  strokeWeight(1);
  for (int i = 0; i < edges.size(); i++) {
    PVector v1 = vertices.get(i);
    for (int j = 0; j < edges.get(i).size(); j++) {
      PVector v2 = vertices.get(edges.get(i).get(j));
      stroke(0, 100, 230);
      line(v1.x, v1.y, v2.x, v2.y);
    }
  }  
}

void drawCurrentVertex() {
  strokeWeight(2);
  if (previousVertex != null) {
    stroke(230, 100, 70);
    fill(230, 50, 70, 100);
    PVector pv = vertices.get(previousVertex);
    ellipse(pv.x, pv.y, 15, 15);
  } 
  
  strokeWeight(1);
  if (graphInteractionMode == GraphInteractionMode.SplitEdge) {
    Pair<PVector, Pair<Integer, Integer>> splitEdge = getEdgeClosestToMouse();
    if (splitEdge == null) return;
    stroke(0, 220, 230);
    fill(70, 220, 180, 100);
    ellipse(splitEdge.a.x, splitEdge.a.y, 15, 15);
  }
}
