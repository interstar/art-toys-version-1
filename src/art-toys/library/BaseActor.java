abstract class BaseActor implements IActor {
  public float x,y;
  public int id=-1;
  int wide,high;

  public int getX() { return (int)x; }
  public int getY() { return (int)y; }
  public void setX(int x) {this.x = x; }
  public void setY(int y) {this.y = y; }  
  
  public int getId() { return id; }
  public float fGetX() { return x; }
  public float fGetY() { return y; }
  public int getWidth() { return wide; }
  public int getHeight() { return high; }
  public int makeUid(Uids _ids) {
    if (id < 0) { id = _ids.next(); }
    return id;
  }
  public abstract boolean hit(int px, int py);
}

