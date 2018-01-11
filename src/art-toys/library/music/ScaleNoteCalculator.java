package arttoys.core.music;

import processing.core.*;

import java.util.Map;
import java.util.HashMap;

public class ScaleNoteCalculator extends BaseNoteCalculator implements INoteCalculator {
  Map<String,Scale> scales;

  int midiMin, midiMax;
  String[] noteNames;

  public ScaleNoteCalculator() {
    setupScales();
    midiMin = 32;
    midiMax = 100;
  }

  public ScaleNoteCalculator(int min, int max) {
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

    select("major");
    setTranspose(0);

  }


  public String noteName(int midiNote) {
    return noteNames[(midiNote-21)%12] + (int)((midiNote-21) / 12) ;
  }


  public void select(String name) {
    selected = name;
    current=scales.get(selected);
    current.setTranspose(getTranspose());
  }


  public void keyPressedControl(int k) {
    // convenience function to update the scale based on one of the
    // number keys. Used in several toys.
    switch (k) {
    case '0' :
      select("chromatic"); break;
    case '1' :
      select("major"); break;
    case '2' :
      select("minor"); break;
    case '3' :
      select("diminished"); break;
    case '4' :
      select("arab"); break;
    case '5' :
      select("debussy"); break;
    case '6' :
      select("gypsy"); break;
    case '7' :
      select("pent1"); break;
    case '8' :
      select("pent2"); break;

    case 'p' :
      shiftTranspose(1); break;
    case 'l' :
      shiftTranspose(-1); break;

    case 'P' :
      shiftTranspose(7); break;
    case 'L' :
      shiftTranspose(-7); break;


    }


  }

}
