package arttoys.core.actors;

public abstract class BaseBlock extends BaseActor {

  public boolean hit(int px, int py) {
    if (px < x) {return false;}
    if (px > x+wide) {return false;}
    if (py < y) {return false;}
    if (py > y+high) {return false;}
    return true;
  }

  public void setX(int x) { this.x = x; }
  public void setY(int y) { this.y = y; }

  public abstract void draw();
}
