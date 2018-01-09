package arttoys.core;

import java.util.*;

public class BasicBus implements IBus {
   Map<Integer,List<IMessage>> channels;
   public BasicBus() { reset(); }

   public void reset() {
     channels = new HashMap<Integer,List<IMessage>>();
   }

   public List<IMessage> getChannel(int channel) {
     if (!channels.containsKey(channel)) {
      channels.put(channel,new ArrayList<IMessage>());
     }
     return channels.get(channel);
   }

   public void put(int channel,IMessage m) {
     List<IMessage> chan = getChannel(channel);
     chan.add(m);
   }

   public IteratorCollection<IMessage> scan(int channel) {
     return new IteratorCollection<IMessage>(getChannel(channel).iterator());
   }

   public IteratorCollection<IMessage> getBangs(int channel) {
     return new IteratorCollection<IMessage>(
       new FilteredIterator<IMessage>(scan(channel),
                        new FilterTest<IMessage>() { public boolean matches(IMessage m) { return m.isBang(); } }
       ) );
   }

   public IteratorCollection<IMessage> getFloats(int channel) {
     return new IteratorCollection<IMessage>(
       new FilteredIterator<IMessage>(scan(channel),
                        new FilterTest<IMessage>() { public boolean matches(IMessage m) { return m.isFloats(); } }
       ) );
   }


   public String diagnostic() {
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
