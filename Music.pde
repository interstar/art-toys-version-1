import java.util.Map;
import java.util.HashMap;

class Scale {
    int[] scale;
    
    Scale(int[] s) {  scale = s;  }

    int transform(int note) {
      int n = note % 12;
      int c = 0;
      while (scale[(n+c)%12] == 0) { c = c + 1; }
      return note + c;    
    }    
}


double midiToFreq(double midi_note) {
    // from https://gist.github.com/718095
    final double half_step = 1.0594630943592953;  
    final double midi_c0 = 8.175798915643707;
    
    return midi_c0 * pow((float)half_step, (float)midi_note);
}

class NoteCalculator {
  Map<String,Scale> scales;
  Scale current;
  
  NoteCalculator() {
    scales = new HashMap<String,Scale>();
    
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
  
  void setCurrent(String k) {
    current = scales.get(k);
  }

  double heightToMidi(int y,int total) {
    double note = (float)Math.floor(((total-y) / 8) + 30);
    return current.transform((int)note);
  }

  double heightToFreq(int y, int total) {
    return midiToFreq(heightToMidi(y,total)); 
  }  

}

class ScaleBasedFreqStrategy implements IFreqStrategy {
  NoteCalculator nc;
  float high;
  ScaleBasedFreqStrategy(float h) { 
    high = h;
    nc = new NoteCalculator(); 
  }
  
  float rawFreq(float y) { return (float)nc.heightToFreq((int)y,(int)high); }
  float corrected(float f) { return f; } 
}
