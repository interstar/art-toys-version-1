package arttoys.core.actors;

public interface IMover extends IActor {
  public void interact(Iterable<IActor> blocks, Iterable<IMover> movers);
  public void interact(Iterable<IMover> movers);
  public int getId();

  public float getDX();
  public float getDY();
}
