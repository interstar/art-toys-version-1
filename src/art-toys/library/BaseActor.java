package arttoys.core;

public abstract class BaseActor implements IActor {
  public float x,y;

  int wide,high;

  public int getX() { return (int)x; }
  public int getY() { return (int)y; }
  public void setX(int x) {this.x = x; }
  public void setY(int y) {this.y = y; }

  public float fGetX() { return x; }
  public float fGetY() { return y; }

  protected void setWidth(int w) { wide=w; }
  protected void setHeight(int h) {high=h;}

  public int getWidth() { return wide; }
  public int getHeight() { return high; }

  public int id=-1;
  public int getId() { return id; }
  public int makeUid(Uids _ids) {
    if (id < 0) { id = _ids.next(); }
    return id;
  }
  public abstract boolean hit(int px, int py);
}
