class Polygon extends ArrayList<PVector> {
  String label;
  int id;

  Polygon(String label, int id) {
    super();
    this.label = label;
    this.id = id;
  }

  Polygon() {
    super();
    this.label = "Polygon -1";
    this.id = -1;
  }

  public void setId(int id) {
    this.id = id;
    this.label = "Polygon " + id;
  }

  PVector getCentroid() {
    float centroidX = 0;
    float centroidY = 0;
    float signedArea = 0;
    for (int j = 0; j < size(); j++) {
      PVector current = get(j);
      PVector next = get((j + 1) % size());

      float partial = current.x * next.y - next.x * current.y;
      signedArea += partial;

      centroidX += (current.x + next.x) * partial;
      centroidY += (current.y + next.y) * partial;
    }

    signedArea *= 0.5;
    centroidX /= (6 * signedArea);
    centroidY /= (6 * signedArea);

    return new PVector(centroidX, centroidY);
  }

  void show() {
    float centroidX = 0;
    float centroidY = 0;
    float signedArea = 0;
    stroke(0, 255, 130);
    fill(0, 140, 140, 100);
    beginShape();
    for (int j = 0; j < size(); j++) {
      PVector current = get(j);
      vertex(current.x, current.y);

      PVector next = get((j + 1) % size());

      float partial = current.x * next.y - next.x * current.y;
      signedArea += partial;

      centroidX += (current.x + next.x) * partial;
      centroidY += (current.y + next.y) * partial;
    }
    endShape(CLOSE);

    fill(180, 30, 30);
    textSize(50);

    signedArea *= 0.5;
    centroidX /= (6 * signedArea);
    centroidY /= (6 * signedArea);
    //center text
    text(label, centroidX - textWidth(label)/2, centroidY + 25);
  }
}


boolean idAlreadyExists(int id) {
  for (Polygon polygon : polygons) {
    if (polygon.id == id) {
      return true;
    }
  }
  return false;
}
