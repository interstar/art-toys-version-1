package arttoys.core;

public abstract class BaseControlAutomaton implements IAutomatonToy {
  boolean playing = false;
  public void start() { playing = true; }
  public void stop() { playing = false; }
  public boolean isPlaying() { return playing; }

  IBus innerObservingBus;
  public void setBus(IBus bus) { innerObservingBus = bus; }
  public IBus getBus() { return innerObservingBus; }

  int channel;
  public void setChannel(int c) { channel = c; }
  public int  getChannel() { return channel; }

}
