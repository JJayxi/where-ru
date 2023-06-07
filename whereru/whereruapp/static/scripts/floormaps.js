// panning and zooming variables
var panX = 0;
var panY = 0;
var panStartX = 0;
var panStartY = 0;
var zoom = 1.0;
var zoomMin = 0.2;
var zoomMax = 1.7;
// variable used to not display things out of screen
var leftViewX = 0, rightViewX = 0, topViewY = 0, bottomViewY = 0;

// floor class to store the floor image, room polygons and path graph
class Floor {
    constructor(img, rooms, path) {
        this.img = img;
        this.rooms = rooms;
        this.path = path;
    }
}

class Room {
    constructor(id, label, polygon) {
        this.id = id;
        this.label = label;
        this.polygon = polygon;
    }
}

class Path {
    constructor(vertices, edges) {
        this.vertices = vertices;
        this.edges = edges;
    }
}

class Vertex {
    constructor(x, y, edges) {
        this.x = x;
        this.y = y;
        this.edges = edges;
    }
}

//parse text file to create array of rooms
//room file format:
//label:id:x1 y1;x2 y2;x3 y3;...
function parseRooms(roomFile) {
    var rooms = [];
    var lines = roomFile.split("\n");
    for (var i = 0; i < lines.length; i++) {
        var line = lines[i];
        var room = line.split(":");
        var label = room[0];
        var id = room[1];
        var polygon = [];
        var points = room[2].split(";");
        for (var j = 0; j < points.length; j++) {
            var point = points[j].split(" ");
            var x = point[0];
            var y = point[1];
            polygon.push(createVector(x, y));
        }
        rooms.push(new Room(id, label, polygon));
    }
    return rooms;
}

//parse text file to create path graph
//path file format:
//x1,y1     //the vertex with id 0
//x2,y2     //the vertex with id 1
//...
//-------
//0: 1,2,3  //the vertex with id 0 has edges to vertices 1, 2 and 3
//1: 0,2
//...
function parseFloorPath(pathFile) {
    var vertices = [];
    var edges = [];
    var lines = pathFile.split("\n");
    var i = 0;
    //until line doesnt contain ,)
    while (lines[i].includes(",")) {
        var line = lines[i].slice(0, -1);
        var point = line.split(",");
        var x = point[0];
        var y = point[1];
        vertices.push(new Vertex(x, y, []));
        i++;
    }
    j = 0
    while (j < i - 1) {
        var line = lines[j + i + 1].slice(0, -1);
        var edge = line.split(":");
        var id = edge[0];
        var connected = edge[1].split(",");
        for (var h = 0; h < connected.length; h++) {
            vertices[id].edges.push(connected[h]);
        }
        j++;
    }
    let path = new Path(vertices);
    return path;
}

var floor;
var pathVertexIds = [];
var highlightedRoomId = -1;
var centerViewToRoom = false;
// given directory, create floor object
function createFloor(dir) {
    var img = loadImage(dir + "/floorplan.png");
    var rooms;
    var path;
    fetch(dir + "/rooms.txt")
        .then(response => response.text())
        .then((data) => {
            rooms = parseRooms(data);
        }).then(() => {
        fetch(dir + "/paths.txt")
            .then(response => response.text())
            .then((data) => {
                path = parseFloorPath(data);
                floor = new Floor(img, rooms, path);
                //center panning and zooming to floor image center
                panX = 600;
                panY = 800;
                zoom = 0.2;
                computeView();                

            })
            .catch((error) => {
                console.error('Error:', error);
            });
    }).catch((error) => {
        console.error('Error:', error);
    });
}

function preload() {
    floor = createFloor("/static/mapdata/huygens/floor1");
};

function setup() {
    //get size of parent. get div element called p5jscanvas
    let parent_width = document.getElementById("p5jscanvas").offsetWidth;
    let parent_height = document.getElementById("p5jscanvas").offsetHeight;
    
    var canvas = createCanvas(parent_width, parent_height);
    canvas.parent('p5jscanvas');
    computeView();
    
};

function draw() {
    //clear canvas
    background(255);
    if (floor == null) {
        return;
    }

    push();
    //translate(width / 2, height / 2);
    scale(zoom);
    translate(panX, panY);
    //draw image on canvas
    image(floor.img);
    drawRooms(floor.rooms);
    drawPath(floor.path);
    if (pathVertexIds.length > 0) {
        drawPathFromTo(pathVertexIds);
    }
    if (highlightedRoomId != -1) {
        emphasiseRoom(floor.rooms, highlightedRoomId);
    }
    pop();
};

//panning and zooming functions
function mouseDragged() {
    panX += (mouseX - panXStart) / zoom;
    panY += (mouseY - panYStart) / zoom;
    panXStart = mouseX;
    panYStart = mouseY;
    computeView();
}

function mousePressed() {
    panXStart = mouseX;
    panYStart = mouseY;
}

function mouseReleased() {
    panStartX = 0;
    panStartY = 0;
}

function mouseWheel(event) {
    zoom += event.delta * 0.001;
    zoom = constrain(zoom, zoomMin, zoomMax);
    computeView();
    return false;
}

function computeView() {
    //compute view boundaries
    leftViewX = -panX;
    rightViewX = -panX + width / zoom;
    topViewY = -panY;
    bottomViewY = -panY + height / zoom;
}

function drawRooms(rooms) {
    //rect(leftViewX, topViewY, rightViewX - leftViewX, bottomViewY - topViewY);
    for (var i = 0; i < rooms.length; i++) {
        let room = rooms[i];
        let shouldBeDrawn = false;
        for (var j = 0; j < room.polygon.length; j++) {
            var point = room.polygon[j];
            if (point.x > leftViewX && point.x < rightViewX && point.y > topViewY && point.y < bottomViewY) {
                shouldBeDrawn = true;
                break;
            }
        }
        if (!shouldBeDrawn) {
            continue;
        }

        fill(255, 100, 73, 100);
        beginShape();
        for (var j = 0; j < room.polygon.length; j++) {
            var point = room.polygon[j];
            vertex(point.x, point.y);
        }
        endShape(CLOSE);
    }
}

function drawPath(path) {
    strokeWeight(zoom);
    stroke(70, 91, 215);
    for (var i = 0; i < path.vertices.length; i++) {
        let vertex = path.vertices[i];
        for (var j = 0; j < vertex.edges.length; j++) {
            let edge = vertex.edges[j];
            line(vertex.x, vertex.y, path.vertices[edge].x, path.vertices[edge].y);
        }
    }
}

var centerView = false;
function drawPathFromTo(path_vertex_ids) {
    if (path_vertex_ids.length < 2) {
        return;
    }

    var previousStrokeWeight = strokeWeight();
    // var previousStrokeColor = stroke();
    strokeWeight(10);
    stroke(220, 51, 74);
    
    for (var i = 0; i < path_vertex_ids.length - 1; i++) {
        let vertex = floor.path.vertices[path_vertex_ids[i]];
        let next_vertex = floor.path.vertices[path_vertex_ids[i + 1]];
        line(vertex.x, vertex.y, next_vertex.x, next_vertex.y);
    }    

    if (!centerView) {
        return;
    }
    centerView = false;

    //reset for rooms
    strokeWeight(0);
    stroke(0, 0, 0);

    //calculate pan and zoom to center path
    let x_min = Infinity;
    let x_max = -Infinity;
    let y_min = Infinity;
    let y_max = -Infinity;
    for (var i = 0; i < path_vertex_ids.length; i++) {
        let vertex = floor.path.vertices[path_vertex_ids[i]];
        x_min = min(x_min, vertex.x);
        x_max = max(x_max, vertex.x);
        y_min = min(y_min, vertex.y);
        y_max = max(y_max, vertex.y);
    }
    let x_center = (x_min + x_max) / 2;
    let y_center = (y_min + y_max) / 2;
    let x_size = x_max - x_min;
    let y_size = y_max - y_min;

    let x_zoom = width / x_size;
    let y_zoom = height / y_size;
    zoom = min(x_zoom, y_zoom) - 0.5;
    zoom = constrain(zoom, zoomMin, zoomMax);
    panX = -x_center + width / 2 / zoom;
    panY = -y_center + height / 2 / zoom;
    computeView();
}

//Zoom functions for buttons
function zoomIn() {
    zoom += 0.05;
    zoom = constrain(zoom, zoomMin, zoomMax);
    computeView();
}

function zoomOut() {
    zoom -= 0.05;
    zoom = constrain(zoom, zoomMin, zoomMax);
    computeView();
}

//Function to bind zoom funtions to buttons
function bindZoomButtons() {
    if (!document.getElementById("zoomIn") || !document.getElementById("zoomOut")) {
        return;
    }
    document.getElementById("zoomIn").onclick = zoomIn;
    document.getElementById("zoomOut").onclick = zoomOut;
}

//when DOM is loaded, bind zoom functions to buttons
document.addEventListener("DOMContentLoaded", bindZoomButtons);


function emphasiseRoom(rooms, roomLabel) {
    for (var i = 0; i < rooms.length; i++) {
      var room = rooms[i];
      if (room.label === roomLabel) {
        fill(50, 255, 50, 100);
        beginShape();
        for (var j = 0; j < room.polygon.length; j++) {
            var point = room.polygon[j];
            vertex(point.x, point.y);
        }
        endShape(CLOSE);

        if (centerViewToRoom) {
            centerViewToRoom = false;
            //calculate pan and zoom to center room
            let x_min = Infinity;
            let x_max = -Infinity;
            let y_min = Infinity;
            let y_max = -Infinity;

            for (var j = 0; j < room.polygon.length; j++) {
                var point = room.polygon[j];
                x_min = min(x_min, point.x);
                x_max = max(x_max, point.x);
                y_min = min(y_min, point.y);
                y_max = max(y_max, point.y);
            }

            let x_center = (x_min + x_max) / 2;
            let y_center = (y_min + y_max) / 2;
            let x_size = x_max - x_min;
            let y_size = y_max - y_min;

            let x_zoom = width / x_size;
            let y_zoom = height / y_size;
            zoom = min(x_zoom, y_zoom) - 0.5;
            zoom = constrain(zoom, zoomMin, zoomMax);
            panX = -x_center + width / 2 / zoom;
            panY = -y_center + height / 2 / zoom;
        }
        break; 
      }
    }
  }