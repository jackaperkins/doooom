import java.io.*;
import java.util.*;

class Sector implements Serializable {
  Vertex[] verts;
  public int r,g,b; 

  Sector () {
    verts = new Vertex[0];
    r = (int) Math.floor(Math.random()*155) +100;
    g = (int) Math.floor(Math.random()*155)+100;
    b = (int) Math.floor(Math.random()*155)+100;
  }

  void addVertex (Vertex v) {
    Vertex[] newVerts = new Vertex[verts.length + 1];
    
    System.arraycopy(verts, 0, newVerts, 0, verts.length);
    
    newVerts[newVerts.length - 1] = v;
    
    verts = newVerts;
  }
  
  void insertVertex (Vertex a, Vertex b, Vertex n) {
    for(int i =0; i< verts.length; i++) {
      Vertex checkA = verts[i];
      Vertex checkB = verts[(i+1)%verts.length];
       if((a == checkA || a == checkB) && (b == checkA || b == checkB)) {
         ArrayList<Vertex> list = new ArrayList<Vertex>();
         for(int q = 0; q < verts.length; q++) {
           list.add(verts[q]);
         }
         
         list.add((i+1)%list.size(), n);
         verts = (Vertex[])list.toArray(new Vertex[0]);
         return;
       }

    }
    
  }
}