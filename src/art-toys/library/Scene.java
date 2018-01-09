package arttoys.core;

import processing.core.*;

public abstract class Scene  {
  PImage back;
  AbstractQuad[] quads;

  public Scene(String imName, AbstractQuad... qs) {
    back = myLoadImage(imName);
    int nq = qs.length;
    quads = new AbstractQuad[nq];
    for (int i=0;i<nq;i++) { quads[i] = qs[i];  }
  }

  public int wide() { return back.width; }
  public int high() { return back.height; }

  public abstract PImage myLoadImage(String imName);
  public abstract void myBackground();

  public void draw() {
    myBackground();
    for (int i=0;i<quads.length;i++) { quads[i].draw();  }
  }


  public Mayhit<AbstractQuad> hit(int x, int y) {
    for (int i=0;i<quads.length;i++) {
      if (quads[i].hit(x,y)) {
        return new Mayhit<AbstractQuad>(quads[i]);
      }
    }
    return new Mayhit<AbstractQuad>();
  }
}
