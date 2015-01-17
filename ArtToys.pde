interface IArtToy {
  void reset();
  void sizeInSetup();
  void addObservingInstrument(ObservingInstrument oi);
  
  void nextStep();
  void draw();
  
  void struck(int x, int y);
  void keyPressed(int k);
}

interface IMusicToy {
  void setIFreqStrategy(IFreqStrategy fs);
  IFreqStrategy getIFreqStrategy();
}
