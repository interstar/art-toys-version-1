package arttoys.core;

import processing.core.*;


public class UncertainY implements IFreqStrategy {
  float noise;
  float high;

  public UncertainY(float h, float n) {
    high = h;
    noise = n;
  }

  public float rawFreq(float y) {
    return PApplet.map(y, 0, 1, 1000,0 );
  }

  public float corrected(float f) {
    return (float)(f - (noise/2) + (Math.random()*noise));
  }

  public void controlChange(String key, int val) {
   // TODO ... implement a change in noise according to control
  }
  public void controlChange(String key, String val) {}

}
