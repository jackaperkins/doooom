class ToolSplitSector extends Tool {
  Vertex target;
  boolean mouseAlreadyDown = true;

  Vertex a1, b1, a2, b2;
  PVector p1, p2;
  Sector sector;

  ToolSplitSector (Vertex a1, Vertex b1, PVector p1, Sector s) {
    sector = s;
    this.a1 = a1;
    this.b1 = b1;
    this.p1 = p1;
  }

  void update () {
    if (escapeDown || mLeftDown) {
      done = true;
      return;
    }
    
    canvas.fill(150, 150, 150, 150);
    canvas.line(mouseX/factor, mouseY/factor, p1.x, p1.y);
    canvas.ellipse(p1.x, p1.y, 6, 6);
    for (int v = 0; v < sector.verts.length; v++) {
      Vertex firstVert = sector.verts[v];
      Vertex secondVert = sector.verts[(v+1)%sector.verts.length];

      // dont let us cut across to the same vector
      if (map.sameSegment(a1, b1, firstVert, secondVert)) {
        continue;
      }

      PVector aa = new PVector(firstVert.x, firstVert.y);
      PVector bb = new PVector(secondVert.x, secondVert.y);

      PVector point = pointNearLine(aa, bb, new PVector(mouseX/factor, mouseY/factor), lineRadius);

      // found a valid point on a different segment
      if (point != null) {
        canvas.ellipse(point.x, point.y, 6, 6);

        // make the two new vertexs and insert them
        if (mRightDown) {
          a2 = firstVert;
          b2 = secondVert;
          p2 = point;

          Vertex v1 = new Vertex(p1.x, p1.y);
          map.addVertex(v1);
          Vertex v2 = new Vertex(point.x, point.y);
          map.addVertex(v2);
          sector.insertVertex(a1, b1, v1);
          sector.insertVertex(a2, b2, v2);
          
          map.addSector(sector.split(v1, v2));
          
          done = true;
          return;
        }
      }
    }


    if (mRightDown && !mouseAlreadyDown) {
      // make second point
      done = true;
    }

    if (!mRight) {
      mouseAlreadyDown = false;
    }
  }
}