interface IUIListener {
  void struck(int x, int y);
  void keyPressed(int k);

  void mousePressed();
  void mouseDragged();
  void mouseReleased();
  
}

interface IArtToy extends IUIListener, IObservable   {
  void reset();
  void sizeInSetup();
  
  void nextStep();
  void draw();

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
 
  IBus innerObservingBus;
  void setBus(IBus bus) { innerObservingBus = bus; }
  IBus getBus() { return innerObservingBus; }

  int channel;
  void setChannel(int c) { channel = c; }
  int  getChannel() { return channel; }

}

