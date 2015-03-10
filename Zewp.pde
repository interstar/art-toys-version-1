interface IMover extends IActor {
  void interact(Iterable<IActor> blocks, Iterable<IMover> movers);
  int getId();
}

class Zewp extends BaseActor implements IMover, IObservable {
    float a, da, dx, dy, len, vel, cos_a, sin_a;
    int colour;
    boolean alive;

    int app_width, app_height;
    int newNote;
    
    IBus innerObservingBus;
    int channel;

    public float lastGlyphX, lastGlyphY;
    boolean inFront = false;
    
    Zewp(int id, float x, float y, float a, float len, float vel, int colour, int app_width, int app_height, IBus aBus) {
      setup(id,x,y,a,len,vel,colour,app_width,app_height,aBus);
    }

    void setup(int id, float x, float y, float a, float len, float vel, int colour, int app_width, int app_height, IBus aBus) { 
      this.id = id; 
      this.x = x;
      this.y = y;      
      this.len = len;
      this.vel = vel;
      this.set_angle(0);
      this.colour = colour;
      this.app_width = app_width;
      this.app_height = app_height;
      alive=true;
      newNote=0;
      setBus(aBus);
      
      
      if (rnd.nextInt(100) < 50) {
          da = PI / 12;
      } else {
          da = -PI/12;
      }      
    }
    
    void set_angle(float a) {
      this.a = a;
      cos_a = cos(a);
      sin_a = sin(a);
      dx = cos_a * vel;
      dy = sin_a * vel;
    }


    boolean look_ahead(Iterable<IMover> zewps, Iterable<IActor> glyphs) {
      /* return true if something ahead, otherwise, false */  
      float px,py; // point we're testing
   
      px = x + (cos_a * (len));
      py = y + (sin_a * (len));

      for (int i=0; i<15; i++) {
        if (edge_in_front((int)px,(int)py,app_width,app_height)) {
            return true;
        }

        if (zewp_in_front((int)px,(int)py,zewps)) {
            return true;
        }

        if (glyph_in_front((int)px,(int)py,glyphs)) {
            return true;
        }

        px = px + dx/2;
        py = py + dy/2;
      }
      return false;
    }

    boolean edge_in_front(int x, int y, int app_width, int app_height) {
        if ((dx < 0) && (x < 5)) { return true; }
        if ((dy < 0) && (y < 5)) { return true; }
        if ((dx > 0) && (x > (app_width-5))) { return true; }
        if ((dy > 0) && (y > (app_height-5))) { return true; }
        return false;
    }

    boolean zewp_in_front(int px, int py, Iterable<IMover> zewps) {
        for (IMover z : zewps) {        
            if (z.getId() == id) { continue; /* don't test for self */ }
            if (z.hit((int)px,(int)py)) {
                lastGlyphX = ((Zewp)z).lastGlyphX;
                lastGlyphY = ((Zewp)z).lastGlyphY;
                inFront = true;
                return true;
            }
        }
        inFront = false;
        return false;
    }


    boolean glyph_in_front(int x, int y, Iterable<IActor> glyphs) {
        for (IActor g : glyphs) {
            if (g.hit((int)x,(int)y)) {
                lastGlyphX = g.getX();
                lastGlyphY = g.getY();
                inFront = true;                
                return true;
            }
        }
        inFront = false;
        return false;
    }

    boolean hit(int px, int py) {
    
        PVector my_centre,  the_point, new_point;
    
        my_centre = new PVector(x,y);
        the_point = new PVector(px,py);
        new_point = new PVector(the_point.x, the_point.y);
        new_point.sub(my_centre);
        new_point.rotate(-a);
       
        // now see if it's in the zewp's rectangle
        if (new_point.x < -len) { return false; }
        if (new_point.x > len) { return false; }
        if (new_point.y < -4) { return false; }
        if (new_point.y > 4) { return false; }
        return true;
    }


  void interact(Iterable<IActor> blocks, Iterable<IMover> movers) {
      if (!alive) { return; }
  
      boolean ahead = look_ahead(movers,blocks);
      if (!ahead) {
          x += dx;
          y += dy;
      } else {
          set_angle(a + da);
      }
  
      if ((x < 0) || (x > app_width)) { x = app_width/2; }
      if ((y < 0) || (y > app_height)) { y = app_height/2; }

  }      
  
  void draw() {
      pushMatrix();
        stroke(colour);
        strokeWeight(4);
        float x1, x2, y1, y2;
        x1 = x - cos_a * len;
        y1 = y - sin_a * len;
        x2 = x + cos_a * len;
        y2 = y + sin_a * len;
        line(x1,y1,x2,y2);
      popMatrix();      
  }
   
  float getFreq() { return height-(int)y; } 
  

  void setChannel(int c) { channel = c; }
  int  getChannel() { return channel; }
  void postToBus() {
    IMessage m = new SimpleMessage();
  }
  void setBus(IBus bus) { innerObservingBus = bus; }
  IBus getBus() { return innerObservingBus; }
  String diagnostic() { return "A Zewp! at " + getX() + ", " + getY() + "lastGlyphs:" + lastGlyphX + "," lastGlyphY; }
  
}


class ZewpFactory implements IBlockWorldFactory {
  int noBlocks, noZewps;
  String backImg;


  ZewpFactory(String imgName, int noblocks, int nozewps) {
    noBlocks = noblocks;
    noZewps = nozewps;
    backImg = imgName;
  }
  
  IBlockWorld makeWorld() {
    ArrayList<IActor> blocks = new ArrayList<IActor>();
    ArrayList<Zewp> zewps = new ArrayList<Zewp>();

    PImage im = loadImage(backImg);
    
    int n;  
    String name;
    NoteCalculator nc = new NoteCalculator();
    IFreqStrategy fs = new ScaleBasedFreqStrategy(nc,im.height);
    
    for (int i=0;i<12;i++) {
       MusicActor b = new FlowerBlock(rnd.nextInt(im.width),rnd.nextInt(im.height-20));
       b.setFreqStrategy(fs); 
       blocks.add(b);
    }
    
    for (int i=0;i<6;i++) {
      IMusicToy mt = new BaseMusicToy();
      mt.addObservingInstrument(new OSCObservingInstrument("127.0.0.1", 9004, "/channel"+i));
      mt.setFreqStrategy(fs);
      Zewp z = new Zewp2(i, rnd.nextInt(im.width),rnd.nextInt(im.height-20), 0, 10, 2, color(255,255,200), im.width, im.height,mt);
      zewps.add(z);
    }
    
    return new ZewpWorld(backImg,blocks,zewps,fs);
  }
}

class ZewpWorld extends BaseControlAutomaton implements IAutomatonToy, IBlockWorld {

  ArrayList<IMover> zewps;
  BaseBlockWorld blocks = new BaseBlockWorld();

  Random rnd;  
  
  PImage backImg;
  int wide=100;
  int high=100;
  
  IMusicToy innerMusicToy = new BaseMusicToy();  

  ZewpWorld(String backImgName, ArrayList<IActor> bs, ArrayList<Zewp> zs, IFreqStrategy fs) {
    backImg = loadImage(backImgName);

    wide=backImg.width;
    high=backImg.height;  

    zewps = new ArrayList<IMover>();
    for (IActor b : bs) { blocks.addBlock(b); }
    for (IMover z : zs) { zewps.add(z); }
    
    innerMusicToy.setFreqStrategy(fs);
    
  }

  void sizeInSetup() { size(wide,high); }
  
  void struck(int x, int y) { }
  void reset() {
    
  };

  void nextStep() {
    for (IMover z : zewps) { 
      z.interact(blocks.itBlocks(),new IteratorCollection<IMover>(zewps.iterator()));
    }  
  }

  
  void draw() {
    background(backImg);
    blocks.draw();
    for (IMover z : zewps) { 
      z.draw(); 
    }  
  }

  void setScale(String scale) {
    innerMusicToy.getFreqStrategy().controlChange("scale",scale);
  }

  void keyPressed(int k) {
    innerMusicToy.getFreqStrategy().controlChange("scale",k);
  }

  boolean blockSelected() { return blocks.blockSelected(); }
  void mousePressed() { blocks.mousePressed(); }
  void mouseReleased() { blocks.mouseReleased(); }  
  void mouseDragged() { blocks.mouseDragged(); }
  IActor selectedBlock() throws NoSelectedBlockException { return blocks.selectedBlock(); }
  Iterable<IActor> itBlocks() { return blocks.itBlocks(); }
  void addBlock(IActor block) { blocks.addBlock(block); } 
}

