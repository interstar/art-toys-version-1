public interface IObservable extends IBusUser, IDiagnostic {
  void setChannel(int channel);
  int getChannel();
}


