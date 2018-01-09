package arttoys.core;

import processing.core.*;

public abstract class AbstractQuad {
  PVector[] verts;

  AbstractQuad(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    verts = new PVector[4];
    verts[0] = new PVector(x1,y1);
    verts[1] = new PVector(x2,y2);
    verts[2] = new PVector(x3,y3);
    verts[3] = new PVector(x4,y4);
  }

  abstract void draw();

  public boolean hit(int px, int py) {
    int num = verts.length;
    int i, j = num - 1;
    boolean oddNodes = false;
    for (i = 0; i < num; i++) {
      PVector vi = verts[i];
      PVector vj = verts[j];
      if (vi.y < py && vj.y >= py || vj.y < py && vi.y >= py) {
        if (vi.x + (py - vi.y) / (vj.y - vi.y) * (vj.x - vi.x) < px) {
          oddNodes = !oddNodes;
        }
      }
      j = i;
    }
    return oddNodes;
  }

}
