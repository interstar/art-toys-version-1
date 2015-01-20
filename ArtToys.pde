interface IArtToy {
  void reset();
  void sizeInSetup();
  
  void nextStep();
  void draw();
  
  void struck(int x, int y);
  void keyPressed(int k);

  void mousePressed();
  void mouseDragged();
  void mouseReleased();
}


interface IAutomatonToy extends IArtToy {
  void start();
  void stop();
  boolean isPlaying();
}

abstract class BaseControlAutomaton implements IAutomatonToy {
  boolean playing = false;
  void start() { playing = true; }
  void stop() { playing = false; }
  boolean isPlaying() { return playing; } 
}

