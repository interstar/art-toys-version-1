public interface IActor {  
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
  
  int makeUid(Uids _ids);
  
  void draw();  
}
