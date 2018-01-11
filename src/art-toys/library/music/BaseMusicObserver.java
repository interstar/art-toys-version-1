package arttoys.core.music;

import arttoys.core.IBus;

public abstract class BaseMusicObserver implements IMusicObserver {
  IFreqStrategy freqStrat = new IdentityFreqStrategy();

  public void setFreqStrategy(IFreqStrategy fs) {freqStrat = fs;}
  public IFreqStrategy getFreqStrategy() { return freqStrat; }

  public IBus observedBus;
  public void setBus(IBus bus) { observedBus = bus; }
  public IBus getBus() { return observedBus; }
  public void postToBus() { }
  public void scanBus() {}

  public float makeCorrectedFreq(float y) { return freqStrat.corrected(freqStrat.rawFreq(y)); }

  public abstract void playNote(float freq);
}
