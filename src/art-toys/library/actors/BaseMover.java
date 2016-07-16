package arttoys.core.actors;

public abstract class BaseMover extends BaseActor implements IMover {
  float dx, dy;
  public float getDX() { return dx; }
  public float getDY() { return dy; }
  protected void setDX(float _x) { dx=_x; }
  protected void setDY(float _y) { dy=_y; }
  protected void invDX() {setDX(-getDX());}
  protected void invDY() {setDY(-getDY());}
}
