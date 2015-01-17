interface IFreqStrategy {
  float rawFreq(float y); // turns the y parameter into a frequency
  float corrected(float freq); // turns a raw frequency into a  
}


class IdentityFreqStrategy implements IFreqStrategy {
  float corrected(float f) { return f; }
  float rawFreq(float y) { return y; }
}

interface IControlAutomaton extends IArtToy, IMusicToy {
  
  void start();
  void stop();
  boolean isPlaying();

  
}

abstract class BaseControlAutomaton implements IControlAutomaton {
  boolean playing = false;
  void start() { playing = true; }
  void stop() { playing = false; }
  boolean isPlaying() { return playing; } 
}

