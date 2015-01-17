Uids _ids = new Uids();

interface Actor {  
  int getX();
  int getY();
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

abstract class BaseActor implements Actor {
  public float x,y;
  public int id=-1;
  int wide,high;

  int getX() { return (int)x; }
  int getY() { return (int)y; }
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



