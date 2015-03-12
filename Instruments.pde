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


abstract class BaseOSCInstrument implements IObservingOSCInstrument {
  NetAddress myRemoteLocation;
  String path;
  IBus innerBus;
  IFreqStrategy fs;
  OscMessageFactory mFact;
 
  void setIP(String s, int port) {
    myRemoteLocation = new NetAddress(s,port);
  }

  void setPath(String p) { 
    path=p;
    mFact = new OscMessageFactory(path); 
  }

  NetAddress getRemoteLocation() { return myRemoteLocation; }
  OscP5 getOscP5() { return oscP5; }

  void setBus(IBus bus) { innerBus = bus; }
  IBus getBus() { return innerBus; }

  IFreqStrategy getFreqStrategy() { return fs; }
  void setFreqStrategy(IFreqStrategy ifs) { fs = ifs; }

}


abstract class AbstractGenericOscObservingInstrument extends BaseOSCInstrument implements IObservingOSCInstrument  {
    int channel;
  
    AbstractGenericOscObservingInstrument(String ip, int port, String path, int chan, IFreqStrategy fs, IBus bus) {
      setIP(ip,port);
      setPath(path);  
      this.fs = fs;      
      channel = chan;
      customizer = cust;
      setBus(bus);
    }
    
    void postToBus() { }
    
    
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
    
    float makeCorrectedFreq(float y) { return fs.corrected(fs.rawFreq(y)); }
        
}  

class ObInZewp2ArtToys extends AbstractGenericOscObservingInstrument {
    ObInZewp2ArtToys(String ip, int port, String path, int chan, IFreqStrategy fs, IBus bus) {
      super(ip,port,path,chan,fs,bus);
    }
  
    OscMessage makeMessage(int bang, float[] xs) {
      return mFact.make(bang, makeCorrectedFreq(xs[1]),
                            map(xs[0],0,1,0,1000),
                            xs[2],xs[3],xs[4]);
    }
}

class ObInCamMouse2ArtToys extends AbstractGenericOscObservingInstrument {
  
    ObInCamMouse2ArtToys(String ip, int port, String path, int chan, IFreqStrategy fs, IBus bus) {
      super(ip,port,path,chan,fs,bus);
    }

    OscMessage makeMessage(int bang, float[] xs) {
      return mFact.make(bang, makeCorrectedFreq(xs[1]),
                            map(xs[0],0,1,0,1000),
                            xs[2],xs[3],xs[4]);
    }
}

