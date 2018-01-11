package arttoys.core;

public interface IBusUser {
  void setBus(IBus b);
  IBus getBus();
  void postToBus();
}
