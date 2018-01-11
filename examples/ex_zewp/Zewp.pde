import arttoys.core.actors.IMover;
import arttoys.core.actors.BaseMover;

class Zewp extends BaseMover implements IMover, IObservable {
    float a, da,  len, vel, cos_a, sin_a;
    int colour;
    boolean alive;

    int app_width, app_height;
    int newNote;
    
    IBus innerObservingBus;
    int channel;

    public float lastGlyphX, lastGlyphY;
    boolean inFront = false;
    
    Zewp(int id, int chan, float x, float y, float a, float len, float vel, int colour, int app_width, int app_height, IBus aBus) {
      setup(id,chan,x,y,a,len,vel,colour,app_width,app_height,aBus);
    }

    void setup(int id, int chan, float x, float y, float a, float len, float vel, int colour, int app_width, int app_height, IBus aBus) { 
      this.id = id;
      setChannel(chan);
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
      setDX(cos_a * vel);
      setDY(sin_a * vel);
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

        px = px + getDX()/2;
        py = py + getDY()/2;
      }
      return false;
    }

    boolean edge_in_front(int x, int y, int app_width, int app_height) {
        if ((getDX() < 0) && (x < 5)) { return true; }
        if ((getDY() < 0) && (y < 5)) { return true; }
        if ((getDX() > 0) && (x > (app_width-5))) { return true; }
        if ((getDY() > 0) && (y > (app_height-5))) { return true; }
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


  public void interact(Iterable<IMover> movers) { }

  public void interact(Iterable<IActor> blocks, Iterable<IMover> movers) {
      if (!alive) { return; }
  
      boolean ahead = look_ahead(movers,blocks);
      if (!ahead) {
          x += getDX();
          y += getDY();
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
    IMessage m = new FloatMessage( map(getX(),0,app_width,0,1), map(getY(),0,app_height,1,0), map(lastGlyphX,0,app_width,0,1), map(lastGlyphY,0,app_height,1,0), 0, 0 );    
    innerObservingBus.put(getChannel(),m);
    if (inFront) {
      m = new BangMessage();
      innerObservingBus.put(getChannel(),m);
    }
  }
  void setBus(IBus bus) { innerObservingBus = bus; }
  IBus getBus() { return innerObservingBus; }
  String diagnostic() { return "A Zewp! at " + getX() + ", " + getY() + "lastGlyphs:" + lastGlyphX + "," + lastGlyphY; }
  
}


class ZewpWorld extends BaseControlAutomaton implements IAutomatonToy, IBlockWorld {

  ArrayList<IMover> zewps;
  BaseBlockWorld blocks;

  Random rnd;  
  
  PImage backImg;
  int wide=100;
  int high=100;
  
  IBus innerObservingBus;
  int channel;
  
  ZewpWorld(ArrayList<IActor> bs, ArrayList<Zewp> zs, IBus bus) {
    wide = width;
    high = height;
    
    setBus(bus);

    blocks = new BaseBlockWorld();    
    for (IActor b : bs) { blocks.addBlock(b); }

    zewps = new ArrayList<IMover>();
    for (Zewp z : zs) { zewps.add(z); }
  }

  void sizeInSetup() {  }
  
  void struck(int x, int y) { }
  void reset() {
    
  };

  void nextStep() {
    for (IMover z : zewps) { 
      z.interact(blocks.itBlocks(),new IteratorCollection<IMover>(zewps.iterator()));
    }  
  }
  
  void draw() {
    background(0);
    blocks.draw();
    for (IMover z : zewps) { 
      z.draw(); 
    }  
  }

  int getRecommendedWidth() { return wide; }
  int getRecommendedHeight() { return high; }

  void keyPressed(int k) {  }

  boolean blockSelected() { return blocks.blockSelected(); }
  void mousePressed(int mouseX, int mouseY) { blocks.mousePressed(mouseX, mouseY); }
  void mouseReleased() { blocks.mouseReleased(); }  
  void mouseDragged(int mouseX, int mouseY) { blocks.mouseDragged(mouseX, mouseY); }
  IActor selectedBlock() throws NoSelectedBlockException { return blocks.selectedBlock(); }
  Iterable<IActor> itBlocks() { return blocks.itBlocks(); }

  void addBlock(IActor block) { blocks.addBlock(block); }
 
  void postToBus() {
    for (IMover z : zewps) { ((IObservable)z).postToBus(); }     
  } 
  void setBus(IBus bus) { innerObservingBus = bus; }
  IBus getBus() { return innerObservingBus; }
  void setChannel(int c) { channel = c; }
  int  getChannel() { return channel; }
  String diagnostic() { return "Zewp! World with " + zewps.size() + " Zewp!s"; } 
}


class ObInZewp2ArtToys extends BaseObservingOSCInstrument {
    ObInZewp2ArtToys(String ip, int port, String path, int chan, IFreqStrategy fs, IBus bus) {
      super(ip,port,path,chan,fs,bus);
    }
  
    OscMessage makeMessage(int bang, float[] xs) {
      float tone = makeCorrectedFreq(xs[1]);
      float filter =  map(xs[0],0,1,0,1000);
      return mFact.make(bang, tone, filter, xs[2],xs[3],xs[4]);
    }
}

class ObInZewp2ArtToys2 extends BaseObservingOSCInstrument {
    ObInZewp2ArtToys2(String ip, int port, String path, int chan, IFreqStrategy fs, IBus bus) {
      super(ip,port,path,chan,fs,bus);
    }
  
    OscMessage makeMessage(int bang, float[] xs) {
      float tone = makeCorrectedFreq(xs[3]);
      float filter =  map(xs[0],0,1,0,1000);
      return mFact.make(bang, tone, filter, xs[2],xs[1],xs[4]);
    }
}