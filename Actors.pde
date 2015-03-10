Uids _ids = new Uids();

interface IActor {  
  int getX();
  int getY();
  void setX(int x);
  void setY(int y);  
  int getId();
  float fGetX();
  float fGetY();
  boolean hit(int px, int py);

  int getWidth();
  int getHeight();
  
  float getFreq();
  
  int makeUid();
  
  void draw();  
}

abstract class BaseActor implements IActor {
  public float x,y;
  public int id=-1;
  int wide,high;

  int getX() { return (int)x; }
  int getY() { return (int)y; }
  void setX(int x) {this.x = x; }
  void setY(int y) {this.y = y; }  
  
  int getId() { return id; }
  float fGetX() { return x; }
  float fGetY() { return y; }
  int getWidth() { return wide; }
  int getHeight() { return high; }
  int makeUid() {
    if (id < 0) { id = _ids.next(); }
    return id;
  }
  abstract boolean hit(int px, int py);
  abstract float getFreq();
}



