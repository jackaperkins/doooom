import java.io.*;
import java.util.*;

class Sector implements Serializable {
  Vertex[] verts;
  public int r, g, b; 

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
    for (int i =0; i< verts.length; i++) {
      Vertex checkA = verts[i];
      Vertex checkB = verts[(i+1)%verts.length];
      if ((a == checkA || a == checkB) && (b == checkA || b == checkB)) {
        ArrayList<Vertex> list = new ArrayList<Vertex>();
        for (int q = 0; q < verts.length; q++) {
          list.add(verts[q]);
        }

        list.add((i+1)%list.size(), n);
        verts = (Vertex[])list.toArray(new Vertex[0]);
        return;
      }
    }
  }

  // copy vertexes a-through-b to a new sector and return it
  // for ourselves keep vertex b-through-a (looping around verts array)
  Sector split (Vertex aa, Vertex bb) {
    // first check we really own these verts, and what order they're in.
    int aIndex = vertexIndex(aa);
    int bIndex = vertexIndex(bb);

    // For easy procedure next we want to have the lower index one 'first'
    // now the lower index one is a, higher is b
    Vertex a = (aIndex < bIndex) ? aa : bb;
    Vertex b = (bIndex > aIndex) ? bb : aa;
    int start = (aIndex < bIndex) ? aIndex : bIndex;
    int stop = (bIndex > aIndex) ? bIndex : aIndex;

    Sector sibling = new Sector ();

   // loop from a to b position, inclusive of b!
    for(int i = start; i < stop+1; i++) {
      sibling.addVertex(verts[i % verts.length]);
    }
    
    
    
    return sibling;
  }

  // find the index number of a given vertex in our verts list
  int vertexIndex (Vertex v) {
    for (int i =0; i < verts.length; i++) {
      if (verts[i] == v) { 
        return i;
      }
    }

    // error state, someone asked for a vert thats not in our sector
    System.out.println("vertexIndex() couldnt find vertex!");
    return -999;
  }
}