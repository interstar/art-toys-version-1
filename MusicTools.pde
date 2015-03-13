import java.util.*;

interface IMusicObserver extends IObservingController {
   void setFreqStrategy(IFreqStrategy fs);
   IFreqStrategy getFreqStrategy();
   float makeCorrectedFreq(float y); // From a y normalized between 0 and 1
}

class BaseMusicObserver implements IMusicObserver {
  IFreqStrategy freqStrat = new IdentityFreqStrategy();  
  void setFreqStrategy(IFreqStrategy fs) {freqStrat = fs;}
  IFreqStrategy getFreqStrategy() { return freqStrat; }

  IBus observedBus;
  void setBus(IBus bus) { observedBus = bus; }
  IBus getBus() { return observedBus; }  
  void postToBus() { }
  void scanBus() {}
    
  float makeCorrectedFreq(float y) { return freqStrat.corrected(freqStrat.rawFreq(y)); }
  
  void playNote(float freq) {
    // TODO something
  }
}


interface IFreqStrategy {
  float rawFreq(float y); // turns the y parameter into a frequency
  float corrected(float freq); // turns a raw frequency into one corrected by the strategy
  void controlChange(String key, int val); // because some strategies can be updated by an external control
  void controlChange(String key, String val); // or text argument  
}


class IdentityFreqStrategy implements IFreqStrategy {
  float corrected(float f) { return f; }
  float rawFreq(float y) { return y; }
  void controlChange(String key, int val) {}
  void controlChange(String key, String val) {}
}

class UncertainY implements IFreqStrategy {
  float noise;
  float high;
  
  UncertainY(float h, float n) {
    high = h; 
    noise = n;  
  }
  
  float rawFreq(float y) {
    return map(y, 0, 1, 1000,0 ); 
  }
  
  float corrected(float f) {
    return (float)(f - (noise/2) + (Math.random()*noise));
  } 
  
  void controlChange(String key, int val) {
   // TODO ... implement a change in noise according to control 
  } 
  void controlChange(String key, String val) {}
  
}



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
  int midiMin, midiMax;
  String[] noteNames;
  
  NoteCalculator() { 
    setupScales();
    midiMin = 30;
    midiMax = 100; 
  }
  
  NoteCalculator(int min, int max) { 
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
 
  String noteName(int midiNote) {
    return noteNames[(midiNote-21)%12] + (int)((midiNote-21) / 12) ;
  }
  
  void setCurrent(String k) {
    current = scales.get(k);
  }

  double valToMidi(float val) {
    double note = map(val,0,1,midiMin,midiMax);
    int m = current.transform((int)note);
    return m;
  }

  double valToFreq(float v) {
    return midiToFreq(valToMidi(v)); 
  }  

  void keyPressedUpdate(int k) {
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


class ScaleBasedFreqStrategy implements IFreqStrategy {
  NoteCalculator nc;
  ScaleBasedFreqStrategy(NoteCalculator nc) {
    this.nc = nc; 
  }
  
  float rawFreq(float y) { 
    return (float)nc.valToFreq(y);
  }
  
  float corrected(float f) { return f; }
  void setScale(String s) { nc.setCurrent(s); }
 
  void controlChange(String key, int val) {
    if (key == "scale") {
      nc.keyPressedUpdate(val);
    }
  }
  
  void controlChange(String key, String val) {
    if (key == "scale") { 
      setScale(val);
      println("NoteCalculator changed to " + val); 
    }
  }
  
}




