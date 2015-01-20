

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

