interface IFreqStrategy {
  float rawFreq(float y); // turns the y parameter into a frequency
  float corrected(float freq); // turns a raw frequency into a  
}


class IdentityFreqStrategy implements IFreqStrategy {
  float corrected(float f) { return f; }
  float rawFreq(float y) { return y; }
}

interface IControlAutomaton {
  void reset();
  
  void start();
  void stop();
  boolean isPlaying();
  void nextStep();
  void draw();

  //UI  
  void struck(int x, int y); // UI produced something interesting at x, y ... automata needs to respond
  void keyPressed(int k); // key pressed
  
  void addObservingInstrument(ObservingInstrument oi);

  void sizeInSetup();  

  void setIFreqStrategy(IFreqStrategy fs);
  IFreqStrategy getIFreqStrategy();
  
}

abstract class BaseControlAutomaton implements IControlAutomaton {
  boolean playing = false;
  void start() { playing = true; }
  void stop() { playing = false; }
  boolean isPlaying() { return playing; } 
}

