package arttoys.core.music;

import java.util.Map;
import java.util.HashMap;

public class ChordNoteCalculator extends BaseNoteCalculator implements INoteCalculator {

  HashMap<String,Scale> chords = new HashMap<String,Scale>();

  public ChordNoteCalculator() {
    chords.put("I", new Scale(new int[]{1,0,0,0,1,0,0,1,0,0,0,0,1}));
    chords.put("IV",new Scale(new int[]{0,0,0,0,0,1,0,0,0,1,0,0,1}));
    chords.put("V",new Scale(new int[]{0,0,1,0,0,0,0,1,0,0,0,1,0}));

    chords.put("i", new Scale(new int[]{1,0,0,1,0,0,0,1,0,0,0,0,1}));
    chords.put("iv",new Scale(new int[]{0,0,0,0,0,1,0,0,1,0,0,0,1}));
    chords.put("v",new Scale(new int[]{0,0,1,0,0,0,0,1,0,0,1,0,0}));

    select("i");
    setTranspose(0);
  }


  public void select(String name) {
    selected = name;
    current=chords.get(selected);
    current.setTranspose(getTranspose());
  }



  public void keyPressedControl(int k) {
      // convenience function to update the scale based on one of the
      // number keys. Used in several toys.
      switch (k) {

      case '1' :
        select("i");
        break;

      case '4' :
        select("iv");
        break;
      case '5' :
        select("v");
        break;


      case 'p' :
        shiftTranspose(1);
        break;
      case 'l' :
        shiftTranspose(-1);
        break;
      case 'P' :
        shiftTranspose(7);
        break;
      case 'L' :
        shiftTranspose(-7);
        break;
      }
  }
}
