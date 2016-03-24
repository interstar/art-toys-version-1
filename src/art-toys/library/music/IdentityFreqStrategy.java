package arttoys.core.music;

public class IdentityFreqStrategy implements IFreqStrategy {
  public float corrected(float f) { return f; }
  public float rawFreq(float y) { return y; }
  public void controlChange(String key, int val) {}
  public void controlChange(String key, String val) {}
}
