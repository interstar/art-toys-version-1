package arttoys.core;

public interface IObservable extends IBusUser, IDiagnostic {
  public void setChannel(int channel);
  public int getChannel();
}
