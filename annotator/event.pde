//when mouse is pressed, add a point to the currentPolygon
void mouseClicked() {
  if (drawingPolygons) polygonMode.mouseClick();
  else graphMode.mouseClick();
}

//when space is pressed, add the currentPolygon to the list of polygons and clear the currentPolygon
void keyPressed() {
  if (drawingPolygons) polygonMode.keyPress();
  else graphMode.keyPress();

  if (key == 'x') {
    drawingPolygons = !drawingPolygons;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom -= e * 0.1;
  if (zoom < 0.1) zoom = 0.1;
  if (zoom > 10) zoom = 10;
}

void mousePressed() {
  panXStart = mouseX;
  panYStart = mouseY;
}

void mouseDragged() {
  panX += mouseX - panXStart;
  panY += mouseY - panYStart;
  panXStart = mouseX;
  panYStart = mouseY;
}

void mouseReleased() {
  panXStart = 0;
  panYStart = 0;
}

float targetX, targetY;
void mouseMoved() {
  if (drawingPolygons) polygonMode.updateTarget();
  else graphMode.updateTarget();
}
