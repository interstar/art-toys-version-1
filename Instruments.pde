import oscP5.*;
import netP5.*;

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;


interface ObservingController {  
  void changed(String... params);
  void changed(float... params);
}

interface ObservingInstrument {
  void playNote(float freq);
} 

interface ObservingOSC {
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

class MinimObservingInstrument implements ObservingInstrument {
  
  MinimObservingInstrument() {
    minim = new Minim(this);
    out = minim.getLineOut();
  }
  
  void playNote(float freq) {
    out.playNote( 0.0, 0.6, new SineInstrument( freq ));
  }

  void changed(String... params) {};
  void changed(float... params) {};  
  
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


class BaseOSCInstrument implements ObservingOSC {
  OscP5 oscP5 = new OscP5(this,9001);  
  NetAddress myRemoteLocation;
  String path;

  void setIP(String s, int port) {
    myRemoteLocation = new NetAddress(s,port);
  }

  void setPath(String p) { path=p; }

  NetAddress getRemoteLocation() { return myRemoteLocation; }
  OscP5 getOscP5() { return oscP5; }
  
}

class OSCObservingInstrument extends BaseOSCInstrument implements ObservingInstrument, ObservingOSC, ObservingController {
  String path;

  OSCObservingInstrument(String s, int port) {
    setIP(s,port); 
  }

  void playNote(float freq) {
    OscMessage myMessage = (new OscMessageFactory("/pitch")).make(freq,0);
    oscP5.send(myMessage, getRemoteLocation());   
  }
  
  void changed(String... params){};
  void changed(float... params){};  

}

class ZewpOSCObservingInstrument extends BaseOSCInstrument implements ObservingInstrument, ObservingController, ObservingOSC {
  
  ZewpOSCObservingInstrument(String ip, int port, String path) {
    oscP5 = new OscP5(this,9001); 
    setIP(ip,port);
    setPath(path);
  } 

  void changed(String... params) {
     oscP5.send( (new OscMessageFactory(path)).make(params), myRemoteLocation); 
  }
  
  void changed(float... params)  { 
     oscP5.send( (new OscMessageFactory(path)).make(params), myRemoteLocation); 
  }
  
  void playNote(float freq) { }
}
