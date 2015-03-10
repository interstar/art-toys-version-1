import oscP5.*;
import netP5.*;

OscP5 oscP5 = new OscP5(this,9001); // one, instantiated once 


interface IObservingOSCInstrument extends IOBservingController {
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

  void setIP(String s, int port) {
    myRemoteLocation = new NetAddress(s,port);
  }

  void setPath(String p) { path=p; }

  NetAddress getRemoteLocation() { return myRemoteLocation; }
  OscP5 getOscP5() { return oscP5; }
  
}


class OSCObservingInstrument extends BaseOSCInstrument implements IObservingInstrument, IObservingOSCInstrument {
  
  OSCObservingInstrument(String ip, int port, String path) {
    setIP(ip,port);
    setPath(path);
  } 

  void changed(String... params) {
     oscP5.send( (new OscMessageFactory(path)).make(params), myRemoteLocation); 
  }
  
  void changed(float... params)  { 
     oscP5.send( (new OscMessageFactory(path)).make(params), myRemoteLocation); 
  }
  
  void playNote(float freq) {
    //changed(1,freq,50000,freq);
    changed((int)map(freq,0,1000,1,127),80,2,3); 
  }
 
  String diagnostic() {
    return "" + getRemoteLocation() + " // " + path;
  }
 
  
}
