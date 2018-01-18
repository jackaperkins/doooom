class Map {
  Sector[] sectors;
  Vertex[] verts;

  Map () {
    sectors = new Sector[0];
    verts = new Vertex[0];
  }

  void addSector (Sector s) {
    sectors = (Sector[]) expand(sectors, sectors.length+1);
    sectors[sectors.length-1] = s;
  }

  void addVertex (Vertex v) {
    verts = (Vertex[]) expand(verts, verts.length+1);
    verts[verts.length-1] = v;
  }

  void addVertices (Vertex[] list) {
    for (int i = 0; i < list.length; i++) {
      Vertex v = list[i];
      verts = (Vertex[]) expand(verts, verts.length+1);
      verts[verts.length-1] = v;
    }
  }

  void drawSectors () {
    for (int k = 0; k < sectors.length; k++) {
      Sector s = sectors[k];
      canvas.stroke(255);
      canvas.fill(iToC(k, 5), iToC(k+2, 3), iToC(k, 7), 150);
      canvas.beginShape();
      for (int i = 0; i < s.verts.length; i++) {
        Vertex currentPoint = s.verts[i];
        canvas.ellipse(currentPoint.x, currentPoint.y, 3, 3);
        canvas.vertex(currentPoint.x, currentPoint.y);
      }
      canvas.endShape(CLOSE);
    }
  }

  Vertex hoverVertex () {
    for (int i =0; i < verts.length; i++) {
      Vertex point = verts[i];
      if (abs(mouseX/factor - point.x) < 8 && abs(mouseY/factor - point.y) < 8 ) {
        return point;
      }
    }
    return null;
  }
  
  // return true if first pair matches second pair, 
  boolean sameSegment (Vertex a1, Vertex b1, Vertex a2, Vertex b2) {
    if(a1 == a2 && b1 == b2) {
      return true;
    }
      if(a1 == b2 && b1 == a2) {
      return true;
    }
    return false;
  }
}