import java.util.*;

class Chime extends BaseActor implements IActor, IObservable {
  int rad,wide,high,channel;
  IBus innerObservingBus;
  
  Chime(int r, int x, int y, int w, int h, int chan, IBus bus) {
    makeUid();
    rad  = r;
    high = h;
    wide = w;
    this.x = x;
    this.y = y;    
    setBus(bus);
    setChannel(chan);
  }
  
  boolean hit(int ox, int oy) {
    return close(ox,oy,x,y,rad);
  }
    
  void setChannel(int c) { channel = c; }
  int  getChannel() { return channel; }
  
  void postToBus() {
    IMessage m = new FloatMessage(map(this.x,0,wide,0,1), map(this.y,0,high,0,1),0,0,0,0);
    innerObservingBus.put(channel,m);
    m = new BangMessage();
    innerObservingBus.put(channel,m);
  }
  
  void setBus(IBus bus) { innerObservingBus = bus; }
  IBus getBus() { return innerObservingBus; }
  String diagnostic() { return "A Chime " + this.x + ", " + this.y; }
  
  void draw() {
    stroke(255);
    fill(100,255,100,200);
    ellipse(x,y,rad*2,rad*2);
  }
}

class CamHarp implements IAutomatonToy, ICamouseUser, IBlockWorld {
    Camouse camouse;
    PApplet pa;
    BaseBlockWorld chimes = new BaseBlockWorld();
    IBus innerObservingBus; 
    
    int noRows=4;
    int rowOffset = 110;
    int rowLength = 12; 
            
    CamHarp(PApplet pa, IBus bus) {
      this.pa = pa;
      sizeInSetup();
      camouse = new Camouse(pa, bus);
      setBus(bus);
      reset();      
    }
    
    PApplet getApp() { return pa; }
    
    void reset() {      
      chimes = new BaseBlockWorld();
      for (int r = 0; r<noRows;r++) {
        for (int c = 0; c<rowLength;c++) {
          addBlock(new Chime(15,(c+1)*50,50+r*rowOffset,640, 480, r, innerObservingBus));
        }
      }
    }

    boolean isPlaying() { return true; }
    void start() {}
    void stop() {}
    
    boolean blockSelected() { return chimes.blockSelected(); }
    void mousePressed() { chimes.mousePressed(); }
    void mouseReleased() { chimes.mouseReleased(); }  
    void mouseDragged() { chimes.mouseDragged(); }
    IActor selectedBlock() throws NoSelectedBlockException { return chimes.selectedBlock(); }
    Iterable<IActor> itBlocks() { return chimes.itBlocks(); }
    void addBlock(IActor block) { chimes.addBlock(block); } 

    
    void draw() {
      drawVideo();
      chimes.draw();
      drawCursor();
    }
    
    void drawVideo() {
      camouse.draw();
      image(camouse.getVideo(), 0, 0);
    }
    void sizeInSetup() { size(640,480); }
    
    void camouseStep() {}
    
    void drawCursor() {
        stroke(255);
        fill(100,100,255,200);    
        ellipse(camouse.x(), camouse.y(), 10, 10);
    }
     
    void nextStep() {
      struck(camouse.x(), camouse.y());
    } 
     
    void struck(int x, int y) {
      for (IActor c : chimes.itBlocks()) {
        if (c.hit(x,y)) {
          ((Chime)c).postToBus();
        }
      }
    }
    
    void keyPressed(int k) {
      switch (k) {
        case ' ' : 
           reset();
           break; 
      }
    }
 
  void setChannel(int c) { }
  int  getChannel() { return 0; }
  
  void setBus(IBus bus) { innerObservingBus = bus; }
  void postToBus() { }
  String diagnostic() { return "A CamHarp"; }
  IBus getBus() { return innerObservingBus; }  
}

class ObInCamHarp2ArtToys extends BaseObservingOSCInstrument {
  
    ObInCamHarp2ArtToys(String ip, int port, String path, int chan, IFreqStrategy fs, IBus bus) {
      super(ip,port,path,chan,fs,bus);
    }

    OscMessage makeMessage(int bang, float[] xs) {
      return mFact.make(bang, makeCorrectedFreq(xs[0]),
                            map(xs[1],0,1,0,1000),
                            xs[2],xs[3],xs[4]);
    }
}

