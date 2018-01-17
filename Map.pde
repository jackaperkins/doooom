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
}