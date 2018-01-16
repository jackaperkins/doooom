PVector pointOnLine (PVector a, PVector b, PVector p) {
  float vAPx = p.x - a.x;
  float vAPy = p.y - a.y;
  float vABx = b.x - a.x;
  float vABy = b.y - a.y;
  float sqDistanceAB = pow(a.dist(b), 2);
  float ABAPproduct = vABx*vAPx + vABy*vAPy;
  
  float amount = ABAPproduct / sqDistanceAB;
  
  // amount is % along the line, bounded:
  if (amount > 1) amount = 1;
  if (amount < 0) amount = 0;
  float nx = (amount * (b.x - a.x)) + a.x;
  float ny = (amount * (b.y - a.y)) + a.y;
  return new PVector(nx, ny);
}

PVector pointNearLine(PVector a, PVector b, PVector p, float distance) {
  PVector linePoint = pointOnLine(a,b,p);
  if(p.dist(linePoint)<distance){
   return linePoint; 
  }
  return null;
}