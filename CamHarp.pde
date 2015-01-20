
class Chime extends MusicActor implements Actor, IMusicToy {
  int rad,wide,high;
  Chime(int r, int x, int y, int h) {
    makeUid();
    rad  = r;
    high = h;
    this.x = x;
    this.y = y;
  }
  
  boolean hit(int ox, int oy) {
    return close(ox,oy,x,y,rad);
  }
  
  float getFreq() { return map(y,0,high,1000,0); }
  
  void draw() {
    stroke(255);
    fill(100,255,100,200);
    ellipse(x,y,rad*2,rad*2);
  }
}

class CamHarp extends BaseMusicToy implements IAutomatonToy, ICamouseUser, IMusicToy {
    Camouse camouse;
    PApplet pa;
    
    ArrayList<Chime> chimes = new ArrayList<Chime>();
    
    CamHarp(PApplet pa) {
      this.pa = pa;
      sizeInSetup();
      camouse = new Camouse(pa);
      setFreqStrategy(new ScaleBasedFreqStrategy(480));
      reset();      
    }
    
    PApplet getApp() { return pa; }
    
    void reset() {
      chimes = new ArrayList<Chime>();
      for (int r = 0; r<8;r++) {
        for (int c = 0; c<4;c++) {
          chimes.add(new Chime(15,(c+1)*130,40+r*70,480));
        }
      }
    }
        
    void draw() {
      drawVideo();
      for (Chime c : chimes) {  c.draw();  }
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
      for (Chime c : chimes) {
        if (c.hit(x,y)) {
          playNote(freqStrat.corrected(freqStrat.rawFreq(c.y)));
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
    

    void mousePressed() {}
    void mouseDragged() {}
    void mouseReleased() {}

    boolean isPlaying() { return true; } 
    void start() { }
    void stop() {  }   
}
