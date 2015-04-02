interface IMover extends IActor {
  void interact(Iterable<IActor> blocks, Iterable<IMover> movers);
  void interact(Iterable<IMover> movers);
  public int getId();
  
  public float getDX();
  public float getDY();
}

