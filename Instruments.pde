import oscP5.*;
import netP5.*;

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

OscP5 oscP5 = new OscP5(this,9001); // one, instantiated once 

interface IObservingController {  
  void changed(String... params);
  void changed(float... params);
  String diagnostic();
}

interface IObservingInstrument extends IObservingController {
  void playNote(float freq);
} 

interface IObservingOSCInstrument extends IObservingInstrument {
  void setIP(String ip, int port);
  void setPath(String path);
  OscP5 getOscP5();
  NetAddress getRemoteLocation();
}


class SineInstrument implements Instrument {
  Oscil wave;
  Line  ampEnv;
  
  SineInstrument( float frequency )  {
    wave   = new Oscil( frequency, 0, Waves.SINE );
    ampEnv = new Line();
    ampEnv.patch( wave.amplitude );
  }
  
  void noteOn( float duration ) {
    ampEnv.activate( duration, 0.2f, 0 );
    wave.patch( out );
  }
  
  void noteOff()  {
    wave.unpatch( out );
  }
}

class MinimObservingInstrument implements IObservingInstrument {
  
  MinimObservingInstrument() {
    minim = new Minim(this);
    out = minim.getLineOut();
  }
  
  void playNote(float freq) {
    out.playNote( 0.0, 0.6, new SineInstrument( freq ));
  }

  void changed(String... params) {};
  void changed(float... params) {};  
  
  String diagnostic() {
    return "" + minim + ", " + out;
  }
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
