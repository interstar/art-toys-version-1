public interface IBus extends IDiagnostic {
  // This is the thing that sits in the middle between the toys / automata and the observing instruments
  // Most likely there'll be one per toy. Although sub-elements of toys can have their own reference to it.
  void put(int channel, IMessage m);
  Iterable<IMessage>scan(int channel);
  void reset();
  
  IteratorCollection<IBangMessage> getBangs(int channel);
  IteratorCollection<IFloatMessage> getFloats(int channel);  
}

