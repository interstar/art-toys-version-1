package arttoys.core.music;

import processing.core.*;

abstract class BaseNoteCalculator implements INoteCalculator {

  int transpose=0;
  public void setTranspose(int t) { transpose = t; }
  public int getTranspose() { return transpose; }
  public int shiftTranspose(int dt) {
      setTranspose(getTranspose() + dt);
      return transpose;
  }

  String selected;
  Scale current;
  public String selectedName() { return selected; }
  public abstract void select(String name);



  public double midiToFreq(double midi_note) {
    // from https://gist.github.com/718095
    final double half_step = 1.0594630943592953;
    final double midi_c0 = 8.175798915643707;

    return midi_c0 * PApplet.pow((float)half_step, (float)midi_note);
  }

  public double valToMidi(float val) {
    double note = PApplet.map(val,0,1,32,127);
    int m = current.transform((int)note);
    return m;
  }

  public double valToFreq(float v) {
    return midiToFreq(valToMidi(v));
  }


}
