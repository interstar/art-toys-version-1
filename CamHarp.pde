import java.util.*;

class Chime extends MusicActor implements IActor, IMusicToy {
  int rad,wide,high;
  Chime(int r, int x, int y, int w, int h, IFreqStrategy fs) {
    makeUid();
    rad  = r;
    high = h;
    wide = w;
    this.x = x;
    this.y = y;
    setFreqStrategy(fs);
  }
  
  boolean hit(int ox, int oy) {
    return close(ox,oy,x,y,rad);
  }
  
  float getFreq() { 
    return makeNote(x);
  }
  
  void draw() {
    stroke(255);
    fill(100,255,100,200);
    ellipse(x,y,rad*2,rad*2);
  }
}

class CamHarp extends BaseMusicToy implements IAutomatonToy, ICamouseUser, IMusicToy, IBlockWorld {
    Camouse camouse;
    PApplet pa;
    BaseBlockWorld chimes = new BaseBlockWorld();
    
    int noRows=4;
    int rowOffset = 110;
    int rowLength = 12; 
        
    NoteCalculator nc = new NoteCalculator(32,58);
    ScaleBasedFreqStrategy sbfs = new ScaleBasedFreqStrategy(nc,480);
    
    CamHarp(PApplet pa) {
      this.pa = pa;
      sizeInSetup();
      camouse = new Camouse(pa);
      setFreqStrategy(sbfs);
      reset();      
    }
    
    PApplet getApp() { return pa; }
    
    void reset() {      
      chimes = new BaseBlockWorld();
      for (int r = 0; r<noRows;r++) {
        for (int c = 0; c<rowLength;c++) {
          addBlock(new Chime(15,(c+1)*50,50+r*rowOffset,640, 480, sbfs));
        }
      }

      OSCObservingInstrument[] ois = {
          new OSCObservingInstrument("127.0.0.1", 9004, "/channel0"),
          new OSCObservingInstrument("127.0.0.1", 9004, "/channel1"),  
          new OSCObservingInstrument("127.0.0.1", 9004, "/channel2"),  
          new OSCObservingInstrument("127.0.0.1", 9004, "/channel3")};

      int count=0;  
      for (IActor c : itBlocks() ) {    
          ((Chime)c).addObservingInstrument(ois[(int)(count/rowLength)]);
          count++;
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
          ((Chime)c).playNote(((Chime)c).makeNote(c.getX()));
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
    


}
