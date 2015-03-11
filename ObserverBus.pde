
interface IMessage {
  String toString();
  boolean isBang();
  boolean isFloats();
  boolean isStrings();
}

interface IFloatMessage extends IMessage { float[] getFloats(); }
interface IBangMessage extends IMessage {}
interface IStringMessage extends IMessage { String [] getStrings(); }

class FloatMessage implements IMessage, IFloatMessage {
  float[] floats;
  FloatMessage(float f1, float f2, float f3, float f4, float f5, float f6) {    
    floats = new float[]{f1,f2,f3,f4,f5,f6};  
  }
  String toString()  { 
    String s = "IMessage : ";
    for (int i=0;i<6;i++) { s = s + String.format("%.2f", floats[i]) + ", "; }
    return s;
  } 
  boolean isBang() { return false; }
  boolean isFloats() { return true; }
  boolean isStrings() { return false; }
  
  float[] getFloats() { return floats; }
}

class BangMessage implements IMessage, IBangMessage {
  boolean isBang() { return true; }
  boolean isFloats() { return false; }
  boolean isStrings() { return false; }
  String toString() {  return "IMessage : BANG!"; }
}

interface IBus extends IDiagnostic {
  // This is the thing that sits in the middle between the toys / automata and the observing instruments
  // Most likely there'll be one per toy. Although sub-elements of toys can have their own reference to it.
  void put(int channel, IMessage m);
  Iterable<IMessage>scan(int channel);
  void reset();
  
  IteratorCollection<IBangMessage> getBangs(int channel);
  IteratorCollection<IFloatMessage> getFloats(int channel);  
}

interface IBusUser {
  void setBus(IBus b);
  IBus getBus();
  void postToBus();
}
 
interface IObservingController extends IBusUser {
  void scanBus();
}

interface IObservable extends IBusUser, IDiagnostic {
  void setChannel(int channel);
  int getChannel();
}

class BasicBus implements IBus {
   Map<Integer,List<IMessage>> channels;
   BasicBus() { reset(); }
   void reset() {
     channels = new HashMap<Integer,List<IMessage>>();
   }
   
   List<IMessage> getChannel(int channel) {
     if (!channels.containsKey(channel)) {
      channels.put(channel,new ArrayList<IMessage>()); 
     }
     return channels.get(channel);
   }
   
   void put(int channel,IMessage m) {
     List<IMessage> chan = getChannel(channel); 
     chan.add(m);
   }
   
   IteratorCollection<IMessage> scan(int channel) {
     return new IteratorCollection<IMessage>(getChannel(channel).iterator());
   }
   
   IteratorCollection<IBangMessage> getBangs(int channel) {
     return new IteratorCollection<IBangMessage>(
       new FilteredIterator(scan(channel),
                        new FilterTest<IMessage>() { public boolean matches(IMessage m) { return m.isBang(); } }     
       ) );
   }   
   
   IteratorCollection<IFloatMessage> getFloats(int channel) {
     return new IteratorCollection<IFloatMessage>(
       new FilteredIterator(scan(channel),
                        new FilterTest<IMessage>() { public boolean matches(IMessage m) { return m.isFloats(); } }     
       ) );
   }   


   String diagnostic() { 
     String s = "A BasicBus with " + channels.size() + " channels";
     Iterator it = channels.entrySet().iterator();
     while (it.hasNext()) {
       Map.Entry pair = (Map.Entry)it.next();
       int c = (Integer)pair.getKey();
       s = s + "\n"+c+" : ";
       s = s + "\n  BANGS ";
       for (IMessage m : getBangs(c)) {s = s + "    " + m + "\n"; }
       s = s + "\n  Floats ";
       for (IMessage m : getFloats(c)) {s = s + "    " + m + "\n"; }
     }
     return s;
   }
}

