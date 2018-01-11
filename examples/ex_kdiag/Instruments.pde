import oscP5.*;
import netP5.*;

OscP5 oscP5 = new OscP5(this,9001); // one, instantiated once 


interface IObservingOSCInstrument extends IObservingController, IMusicObserver {
  void setIP(String ip, int port);
  void setPath(String path);
  OscP5 getOscP5();
  NetAddress getRemoteLocation();
}


class OscMessageFactory {
  String path;
  OscMessageFactory(String p) { path = p; }
  
  OscMessage make(String... params) {
      OscMessage msg = new OscMessage(path);
      for (int i=0; i<params.length;i++) {
        msg.add(params[i]);
      }
      return msg;
  }
  
  OscMessage make(float... params) {
      OscMessage msg = new OscMessage(path);
      for (int i=0; i<params.length;i++) {
        msg.add(params[i]);
      }
      return msg;
  }
  
} 


abstract class BaseObservingOSCInstrument implements IObservingOSCInstrument {
  NetAddress myRemoteLocation;
  String path;
  IBus innerBus;
  IFreqStrategy fs;
  OscMessageFactory mFact;
  int channel;
 
  BaseObservingOSCInstrument(String ip, int port, String path, int chan, IFreqStrategy fs, IBus bus) {
    setIP(ip,port);
    setPath(path);  
    this.fs = fs;      
    channel = chan;
    setBus(bus);
  }
  
  
  void setIP(String s, int port) {
    myRemoteLocation = new NetAddress(s,port);
  }

  void setPath(String p) { 
    path=p;
    mFact = new OscMessageFactory(path); 
  }

  NetAddress getRemoteLocation() { return myRemoteLocation; }
  OscP5 getOscP5() { return oscP5; }

  float makeCorrectedFreq(float y) { return fs.corrected(fs.rawFreq(y)); }

  void setBus(IBus bus) { innerBus = bus; }
  IBus getBus() { return innerBus; }
  void postToBus() { }

  IFreqStrategy getFreqStrategy() { return fs; }
  void setFreqStrategy(IFreqStrategy ifs) { fs = ifs; }

  void scanBus() {
    int bang = 0;  
    for (IMessage m : innerBus.getBangs(channel)) { bang=1; }
   
    for (IMessage m : innerBus.getFloats(channel)) {
      float[] xs = ((IFloatMessage)m).getFloats();
      OscMessage om = makeMessage(bang, xs);                                                                 
      oscP5.send(om , myRemoteLocation);
    }      
  }
   
  abstract OscMessage makeMessage(int bang, float[] xs);  

}


