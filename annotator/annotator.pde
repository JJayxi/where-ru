PImage toAnnotate;

String filename = "0500BR01";

void setup() {
  fullScreen();
  toAnnotate = loadImage("resources/" + filename + ".png");
  currentPolygon = new Polygon();
}

void draw() {
  background(0);

  pushMatrix();
  translate(width/2, height/2);
  scale(zoom);
  translate(panX, panY);
  image(toAnnotate, -toAnnotate.width/2, -toAnnotate.height/2);
  strokeWeight(2);
  drawPolygons();
  if (drawingPolygons) drawCurrentPolygon();
  
  drawGraph();
  if (!drawingPolygons) drawCurrentVertex();
  popMatrix();
  drawLineToMouse();

  strokeWeight(1);
  stroke(0);
  noFill();
  ellipse(targetX, targetY, 13, 13);
  fill(255, 0, 0);
  stroke(255, 0, 0);
  ellipse(targetX, targetY, 5, 5);
}
