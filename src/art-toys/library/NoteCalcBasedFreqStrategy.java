package arttoys.core;

public class NoteCalcBasedFreqStrategy implements IFreqStrategy {
  INoteCalculator nc;
  public NoteCalcBasedFreqStrategy(INoteCalculator nc) {
    this.nc = nc;
  }

  public float rawFreq(float y) {
    return (float)nc.valToFreq(y);
  }

  public float corrected(float f) { return f; }
  public void select(String s) { nc.select(s); }

  public void controlChange(String key, int val) {
    if (key == "scale") {
      nc.keyPressedControl(val);
    }
  }

  public void controlChange(String key, String val) {
    if (key == "scale") {
      select(val);
      //println("NoteCalculator changed to " + val);
    }
  }

}
