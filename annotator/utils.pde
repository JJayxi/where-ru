PVector getClosestPointOnLine(PVector edgeStart, PVector edgeEnd, PVector point) {
  PVector edgeDirection = PVector.sub(edgeEnd, edgeStart).normalize();
  PVector v = PVector.sub(point, edgeStart);
  float d = v.dot(edgeDirection);

  if (d <= 0) {
    return edgeStart; // Closest point is the start of the segment
  } else if (d >= edgeStart.dist(edgeEnd)) {
    return edgeEnd; // Closest point is the end of the segment
  }
  
  return PVector.add(edgeStart, edgeDirection.mult(d));
}

class Pair<T1, T2> {
  T1 a;
  T2 b;

  Pair(T1 first, T2 second) {
    this.a = first;
    this.b = second;
  }
}


//return the point on the edge closest to the mouse, and the indexes of the two vertices
Pair<PVector, Pair<Integer, Integer>> getEdgeClosestToMouse() {
  //iterate over all the edges
  float minDist = 1000000000;
  PVector closestPoint = null;
  Pair<Integer, Integer> closestVertices = null;

  for (int i = 0; i < edges.size(); i++) {
    ArrayList<Integer> edge = edges.get(i);
    for (int j = 0; j < edge.size(); j++) {
      PVector p1 = vertices.get(i);
      PVector p2 = vertices.get(edge.get(j));

      //compute the closest point on the edge
      float x = (targetX - width / 2) / zoom - panX;
      float y = (targetY - height / 2) / zoom - panY;
      PVector p = getClosestPointOnLine(p2, p1, new PVector(x, y));
      //compute the distance to the mouse
      float dist = dist(p.x, p.y, x, y);

      //if the distance is smaller than the current minimum, update the minimum
      if (dist < minDist) {
        minDist = dist;
        closestPoint = p;
        closestVertices = new Pair<Integer, Integer>(i, edge.get(j));
      }
    }
  }

  if (closestPoint == null) return null;

  return new Pair<PVector, Pair<Integer, Integer>>(closestPoint, closestVertices);
}

int getClosestVertex() {
  //return the index of the vertex closest to the targetX and targetY
  float x = (targetX - width / 2) / zoom - panX;
  float y = (targetY - height / 2) / zoom - panY;

  int closest = -1;
  float minDist = 100000000;
  for (int i = 0; i < vertices.size(); i++) {
    float dist = dist(x, y, vertices.get(i).x, vertices.get(i).y);
    if (dist < minDist) {
      minDist = dist;
      closest = i;
    }
  }
  return closest;
}

