import java.util.*;

interface IMusicToy {
  void setFreqStrategy(IFreqStrategy fs);
  IFreqStrategy getFreqStrategy();
  void addObservingInstrument(IObservingInstrument oi);
  ArrayList<IObservingInstrument> obIns();
  Iterator<IObservingInstrument> itObIns();
  void playNote(float freq);
  float makeNote(float y);  
}

class BaseMusicToy implements IMusicToy {
  ArrayList<IObservingInstrument> oins = new ArrayList<IObservingInstrument>();
  IFreqStrategy freqStrat = new IdentityFreqStrategy();
  
  void setFreqStrategy(IFreqStrategy fs) {freqStrat = fs;}
  IFreqStrategy getFreqStrategy() { return freqStrat; }
  void addObservingInstrument(IObservingInstrument oi) { oins.add(oi); }
  ArrayList<IObservingInstrument> obIns() { return oins; }
  Iterator<IObservingInstrument> itObIns() { return oins.iterator(); }
  
  float makeNote(float y) { return freqStrat.corrected(freqStrat.rawFreq(y)); }
  
  void playNote(float freq) {
    for (IObservingInstrument oi : oins) {
      println(oi + " playing " + freq);
      oi.playNote(freq);
    }
  }
}


abstract class MusicActor extends BaseActor implements IMusicToy, Actor {
    IMusicToy innerMusicToy = new BaseMusicToy();
    IFreqStrategy getFreqStrategy() { return innerMusicToy.getFreqStrategy(); }
    void setFreqStrategy(IFreqStrategy fs) { innerMusicToy.setFreqStrategy(fs); }
    float makeNote(float y) { innerMusicToy.makeNote(y); }
    void playNote(float freq) { innerMusicToy.playNote(freq); }
    Iterator<IObservingInstrument> itObIns() { return innerMusicToy.itObIns(); }
    ArrayList<IObservingInstrument> obIns() { return innerMusicToy.obIns(); }
    void addObservingInstrument(IObservingInstrument oi) { innerMusicToy.addObservingInstrument(oi); }
    abstract boolean hit(int x, int y);  
}

interface IFreqStrategy {
  float rawFreq(float y); // turns the y parameter into a frequency
  float corrected(float freq); // turns a raw frequency into a  
}


class IdentityFreqStrategy implements IFreqStrategy {
  float corrected(float f) { return f; }
  float rawFreq(float y) { return y; }
}

  class UncertainY implements IFreqStrategy {
    float noise;
    float high;
    
    UncertainY(float h, float n) {
      high = h; 
      noise = n;  
    }
    
   float rawFreq(float y) {
      return map(y, -high/2, high/2, 1000,0 ); 
   }
    
   float corrected(float f) {
      return (float)(f - (noise/2) + (Math.random()*noise));
    }
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
