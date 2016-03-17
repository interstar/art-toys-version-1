package arttoys.core;

public class ScaleBasedFreqStrategy implements IFreqStrategy {
  NoteCalculator nc;
  public ScaleBasedFreqStrategy(NoteCalculator nc) {
    this.nc = nc;
  }

  public float rawFreq(float y) {
    return (float)nc.valToFreq(y);
  }

  public float corrected(float f) { return f; }
  public void setScale(String s) { nc.setCurrent(s); }

  public void controlChange(String key, int val) {
    if (key == "scale") {
      nc.keyPressedUpdate(val);
    }
  }

  public void controlChange(String key, String val) {
    if (key == "scale") {
      setScale(val);
      //println("NoteCalculator changed to " + val);
    }
  }

}
