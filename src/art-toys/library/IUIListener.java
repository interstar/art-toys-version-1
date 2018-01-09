package arttoys.core;

public interface IUIListener {
  void struck(int x, int y);
  void keyPressed(int k);

  void mousePressed(int mouseX, int mouseY);
  void mouseDragged(int mouseX, int mouseY);
  void mouseReleased();

}
