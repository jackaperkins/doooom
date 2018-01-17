import java.util.*;
import java.io.*;
import java.lang.reflect.Method;

PGraphics canvas;
int ww, hh;
int factor = 2; // display factor 1/factor


Tool currentTool;
boolean hovered; // someones hovering, dont draw other shit, asshole

Map map;

// CONFIG NUMBERS
int gridSize = 8;


// tool GUI radiuses
float vertexRadius = 10;
float lineRadius = 6;

PFont mono;

Sector s1;

// button storage
// we need this because storing l/r events requires us to tkae notes
boolean mLeft, mLeftDown, mRight, mRightDown;

void setup () {
  noCursor();
  size(800, 600);
  noSmooth();
  
  map = new Map();
  
  ww = width/factor;
  hh = height/factor;
  canvas = createGraphics(ww, hh);

  mono  = loadFont("mono.vlw");
  textFont(mono, 15);

  background(255);
  canvas.text("", 0, 0);

}



void draw () {

    canvas.beginDraw();
    canvas.background(0, 0, 0);
    drawGrid();

    // do our mouse updates here
    map.drawSectors();
    runTools();


    if (currentTool == null) {
      canvas.stroke(200);
      canvas.line(mouseX/factor-3, mouseY/factor-3, mouseX/factor+3, mouseY/factor+3);
      canvas.line(mouseX/factor+3, mouseY/factor-3, mouseX/factor-3, mouseY/factor+3);
    }
    canvas.endDraw();
    image(canvas, 0, 0, width, height);
  
   mLeftDown = false;
  mRightDown = false;
}

void drawGrid () {
  for (int x =0; x < ww; x += gridSize) {
    canvas.stroke(50);
    canvas.line(x, 0, x, hh);
  }
  for (int y =0; y < hh; y += gridSize) {
    canvas.stroke(60);
    canvas.line(0, y, ww, y);
  }
}

void runTools () {
  // drag vertex
  if (currentTool == null) {
    hovered = false;
    // test for hovering vertex
    Vertex hoveredVert = hoverVertex();
    if (hoveredVert != null) {
      canvas.fill(255);
      canvas.stroke(255);
      canvas.ellipse(hoveredVert.x, hoveredVert.y, 5, 5);
      hovered = true;
      if (mousePressed && (mouseButton == LEFT)) {
        currentTool = new ToolDragVertex (hoveredVert);
      }
      return;
    }

    // hover line segment
    for (int s = 0; s < map.sectors.length; s++) {
      Sector sec = map.sectors[s];
      for (int v = 0; v < sec.verts.length; v++) {
        Vertex firstVert = sec.verts[v];
        Vertex secondVert = sec.verts[(v+1)%sec.verts.length];

        PVector a = new PVector(firstVert.x, firstVert.y);
        PVector b = new PVector(secondVert.x, secondVert.y);

        PVector point = pointNearLine(a, b, new PVector(mouseX/factor, mouseY/factor), lineRadius);
        if (point != null) {

          canvas.stroke(255);
          PVector diff = new PVector(point.x-mouseX/factor, point.y-mouseY/factor);
          diff.normalize();
          diff.mult(10);
          canvas.line(point.x, point.y, point.x-diff.x, point.y-diff.y);
          canvas.line(point.x, point.y, point.x+diff.x, point.y+diff.y);
          hovered = true;

          if (mousePressed && (mouseButton == LEFT)) {
            Vertex newGuy = new Vertex(mouseX/factor, mouseY/factor);
            map.addVertex(newGuy);
            sec.insertVertex(sec.verts[v], sec.verts[(v+1)%sec.verts.length], newGuy);
          } else  if (mousePressed && (mouseButton == RIGHT)) {
            PVector newGuy = new PVector(mouseX/factor, mouseY/factor);
            currentTool = new ToolSplitSector(firstVert, secondVert, point, sec);
            //sec.insertVertex(sec.verts[v], sec.verts[(v+1)%sec.verts.length], newGuy);
          }


          return;
        }
      }
    }
  } else {
    currentTool.update();
    canvas.fill(255);
    canvas.text(getToolName(currentTool), 5, 10);
    if (currentTool.done) {
      currentTool = null;
    }
  }
}

void mousePressed () {
  if (mouseButton == LEFT) {
    mLeft = true;    
    mLeftDown = true;
  } else if (mouseButton == RIGHT) {
    mRight = true;
    mRightDown = true;
  }
}

void mouseReleased () {
  if (mouseButton == LEFT) {
    mLeftDown = false;
    mLeft = false;
  } else if (mouseButton == RIGHT) {
    mRightDown = false;
    mRight = false;
  }
}


Vertex hoverVertex () {
  for (int i =0; i < map.verts.length; i++) {
    Vertex point = map.verts[i];
    if (abs(mouseX/factor - point.x) < 8 && abs(mouseY/factor - point.y) < 8 ) {
      return point;
    }
  }
  return null;
}

void keyPressed () {
  if (key == '1') {
    saveToFile();
  } else if (key == '2') {
    loadFromFile();
  } else if (key== ' ') {
    spawnRandom();
  } else if (key == '0') {
    eraseAll();
  }
}

void spawnRandom () {
  int offX = ww/2 + (int)random(60)-30;
  int offY = hh/2 + (int)random(60)-30;

  int count = floor(random(3)+3);

  for (int i = 0; i <count; i++) {
  }

  Vertex a = new Vertex(-90+offX, 30+offY);
  Vertex b = new Vertex(52+offX, 50+offY);
  Vertex c = new Vertex(70+offX, -10+offY);
  map.addVertex(a);
  map.addVertex(b);
  map.addVertex(c);

  s1 = new Sector();
  s1.addVertex(a);
  s1.addVertex(b);
  s1.addVertex(c);


  map.addSector(s1);
}

void eraseAll () {
  map.sectors = new Sector[0];
  map.verts = new Vertex[0];
}

float iToC (int input, int radix) {
  float divided = (input % radix) /(float)(radix);
  int r = (int) (divided * 155.0);
  return r + 100;
}

String getToolName (Object obj) {
  String toolName = obj.getClass().getName();
  String[] nam;
  toolName = split(toolName, '$')[1];
  return toolName;
}