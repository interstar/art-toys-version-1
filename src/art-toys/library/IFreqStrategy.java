package arttoys.core;

public interface IFreqStrategy {
  float rawFreq(float y); // turns the y parameter into a frequency
  float corrected(float freq); // turns a raw frequency into one corrected by the strategy
  void controlChange(String key, int val); // because some strategies can be updated by an external control
  void controlChange(String key, String val); // or text argument
}
