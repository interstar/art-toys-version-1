package arttoys.core;

public class Cycler {
  double x, dx, min, max;

  public Cycler(double _x, double _dx, double _min, double _max) {
    x   = _x;
    dx  = _dx;
    min = _min;
    max = _max;
  }

  public double next() {
    x=x+dx;
    if (x>max) { dx=-dx; }
    if (x<min) { dx=-dx; }
    return x;
  }
}
