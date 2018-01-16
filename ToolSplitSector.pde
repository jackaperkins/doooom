class ToolSplitSector extends Tool {
  Vertex target;
  boolean mouseAlreadyDown = true;

  Vertex a1, b1;
  PVector p1;
  Sector sector;

  ToolSplitSector (Vertex a1, Vertex b1, PVector p1, Sector s) {
    sector = s;
    this.a1 = a1;
    this.b1 = b1;
    this.p1 = p1;
  }

  void update () {
    canvas.line(mouseX/factor, mouseY/factor, p1.x, p1.y);
    if(mRightDown && !mouseAlreadyDown) {
     done = true; 
    }
    
    if(!mRight) {
     mouseAlreadyDown = false; 
    }
    
  }
}