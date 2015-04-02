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

