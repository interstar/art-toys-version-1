import java.util.*;

class Chime extends MusicActor implements Actor, IMusicToy {
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

class CamHarp extends BaseMusicToy implements IAutomatonToy, ICamouseUser, IMusicToy {
    Camouse camouse;
    PApplet pa;
    
    ArrayList<Chime> chimes = new ArrayList<Chime>();
    NoteCalculator nc = new NoteCalculator(32,46);
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
      chimes = new ArrayList<Chime>();
      for (int r = 0; r<4;r++) {
        for (int c = 0; c<12;c++) {
          chimes.add(new Chime(15,(c+1)*50,50+r*110,640, 480, sbfs));
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
          playNote(c.makeNote(c.x));
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

    ArrayList<UIListener> uils = new ArrayList<UIListener>(); 
    void addUIListener(UIListener uil) { uils.add(uil); }
    Iterable<UIListener> UIListeners() { return new IteratorCollection<UIListener>(uils.iterator()); }
}
