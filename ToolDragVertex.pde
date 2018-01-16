class ToolDragVertex extends Tool {
  Vertex target;

  ToolDragVertex (Vertex t) {
    target = t;
    // super();
  }

  void update () {
    if (mousePressed) {
      target.x = ((mouseX/factor) /8)*8;
      target.y = ((mouseY/factor)/8)*8;
      canvas.stroke(255);
      canvas.noFill();
      canvas.ellipse(target.x, target.y, 15,15);
    } else {
      done = true;
    }
  }
}