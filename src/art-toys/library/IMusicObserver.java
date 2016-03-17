package arttoys.core;

public interface IMusicObserver extends IObservingController {
   void setFreqStrategy(IFreqStrategy fs);
   IFreqStrategy getFreqStrategy();
   float makeCorrectedFreq(float y); // From a y normalized between 0 and 1
}
