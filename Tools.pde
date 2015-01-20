
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

class CyclingColor {
  Cycler r,g,b,a;
  
  CyclingColor(float ir,float ig,float ib,float ia,float dr,float dg,float db,float da) {
    r = new Cycler(ir,dr,0,255);
    g = new Cycler(ig,dg,0,255);
    b = new Cycler(ib,db,0,255);
    a = new Cycler(ia,da,0,255);    
  }
  
  CyclingColor(dr,dg,db,da) {
    CyclingColor(0,0,0,0,dr,dg,db,da);
  }
  
  color next() {
    return color(r.next(),g.next(),b.next(),a.next());
  }
}
