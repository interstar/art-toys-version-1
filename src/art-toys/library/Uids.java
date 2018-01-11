package arttoys.core;

public class Uids {
  private int id=-1;
  public int next() {
    id++;
    return id;
  }
}
