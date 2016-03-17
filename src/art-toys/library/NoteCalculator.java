package arttoys.core;

import processing.core.*;
import java.util.Map;
import java.util.HashMap;



public class NoteCalculator {
  Map<String,Scale> scales;
  Scale current;
  int midiMin, midiMax;
  String[] noteNames;

  public NoteCalculator() {
    setupScales();
    midiMin = 30;
    midiMax = 100;
  }

  public NoteCalculator(int min, int max) {
    setupScales();
    midiMin = min;
    midiMax = max;
  }


  void setupScales() {
    scales = new HashMap<String,Scale>();
    noteNames = new String[]{"A","A#","B","C","C#","D","D#","E","F","F#","G","G#"};

    scales.put("chromatic",  new Scale(new int[]{1,1,1,1,1,1,1,1,1,1,1,1,1}));
    scales.put("major",      new Scale(new int[]{1,0,1,0,1,1,0,1,0,1,0,1,1}));
    scales.put("minor",      new Scale(new int[]{1,0,1,1,0,1,0,1,1,0,0,1,1}));
    scales.put("diminished", new Scale(new int[]{1,0,1,1,0,1,0,1,1,0,1,0,1}));
    scales.put("arab",       new Scale(new int[]{1,0,1,0,1,1,1,0,1,0,1,0,1}));
    scales.put("debussy",    new Scale(new int[]{1,0,1,0,1,0,1,0,1,0,1,0,1}));
    scales.put("gypsy",      new Scale(new int[]{1,0,1,1,0,0,1,1,1,0,1,0,1}));
    scales.put("pent1",      new Scale(new int[]{0,0,1,0,1,0,0,1,0,1,0,1,0}));
    scales.put("pent2",      new Scale(new int[]{1,0,0,1,0,1,0,1,0,0,1,0,1}));

    current = scales.get("major");

  }



  public static double midiToFreq(double midi_note) {
    // from https://gist.github.com/718095
    final double half_step = 1.0594630943592953;
    final double midi_c0 = 8.175798915643707;

    return midi_c0 * PApplet.pow((float)half_step, (float)midi_note);
  }


  public String noteName(int midiNote) {
    return noteNames[(midiNote-21)%12] + (int)((midiNote-21) / 12) ;
  }

  public void setCurrent(String k) {
    current = scales.get(k);
  }

  public double valToMidi(float val) {
    double note = PApplet.map(val,0,1,midiMin,midiMax);
    int m = current.transform((int)note);
    return m;
  }

  public double valToFreq(float v) {
    return midiToFreq(valToMidi(v));
  }

  public void keyPressedUpdate(int k) {
    // convenience function to update the scale based on one of the
    // number keys. Used in several toys.
    switch (k) {
    case '0' :
      setCurrent("chromatic"); break;
    case '1' :
      setCurrent("major"); break;
    case '2' :
      setCurrent("minor"); break;
    case '3' :
      setCurrent("diminished"); break;
    case '4' :
      setCurrent("arab"); break;
    case '5' :
      setCurrent("debussy"); break;
    case '6' :
      setCurrent("gypsy"); break;
    case '7' :
      setCurrent("pent1"); break;
    case '8' :
      setCurrent("pent2"); break;
    }
  }

}
