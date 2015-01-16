import oscP5.*;
import netP5.*;

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;


interface ObservingInstrument {
  void playNote(float freq);
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
}

class OSCObservingInstrument implements ObservingInstrument {
  OscP5 oscP5;
  NetAddress myRemoteLocation;

  OSCObservingInstrument() {
    oscP5 = new OscP5(this,9003);
    myRemoteLocation = new NetAddress("127.0.0.1",9004);
    //myRemoteLocation = new NetAddress("127.0.0.1",5001);     
  }
  
  void playNote(float freq) {
    OscMessage myMessage = new OscMessage("/pitch");
    //  OscMessage myMessage = new OscMessage("/ML");
    myMessage.add(freq);
    myMessage.add(0);
    oscP5.send(myMessage, myRemoteLocation);   
  }
}
