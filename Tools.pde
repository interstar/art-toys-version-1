
//Geometry
boolean approx(float a, float b, float marg) {
    return ((a > b-marg) && (a < b+marg));
}

boolean close(float x1, float y1, float x2, float y2, float dist) {
    float xdiff = x1-x2;
    float ydiff = y1-y2;
    return (sqrt(xdiff*xdiff+ydiff*ydiff) <= dist);
}

class Uids {
  private int id=-1;
  int next() {
    id++;
    return id;
  }
}

class Cycler {
  float x, dx, min, max;
  Cycler(float _x, float _dx, float _min, float _max) {
    x   = _x;
    dx  = _dx;
    min = _min;
    max = _max;
  }
  
  float next() {
    x=x+dx;
    if (x>max) { dx=-dx; }
    if (x<min) { dx=-dx; }
    return x;
  } 
}

interface IColor {
  color next();
}

class AColor implements IColor {
  color col;
  AColor(int r, int g, int b, int a) { col = color(r,g,b,a); }
  color next() { return col; }
}

class CyclingColor implements IColor {
  Cycler r,g,b,a;
  
  void setup(float ir,float ig,float ib,float ia,float dr,float dg,float db,float da) {
    r = new Cycler(ir,dr,0,255);
    g = new Cycler(ig,dg,0,255);
    b = new Cycler(ib,db,0,255);
    a = new Cycler(ia,da,0,255);    
  }
  
  CyclingColor(float ir,float ig,float ib,float ia,float dr,float dg,float db,float da) {
    setup(ir,ig,ib,ia,dr,dg,db,da);
  }

  CyclingColor(float dr,float dg,float db,float da) {
    setup(0.0,0.0,0.0,0.0,dr,dg,db,da);
  }
  
  color next() {
    return color(r.next(),g.next(),b.next(),a.next());
  }
}

import java.util.*;
public class IteratorCollection<E> implements Iterable<E> {
    private Iterator<E> it;

    public IteratorCollection(Iterator<E> it) { this.it = it;  }

    @Override
    public Iterator<E> iterator() { return it; }

}
