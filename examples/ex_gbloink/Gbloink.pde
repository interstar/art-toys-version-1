
import arttoys.core.actors.IMover;
import arttoys.core.actors.IActor;

import arttoys.core.actors.BaseMover;

class Ball extends BaseMover implements IObservable, IMover {
  
  PVector centre;
  color colour;
  Ball other;
  int rad;
  boolean bounced=false;
  int id;
  
  Ball(int ch, color col, float x, float y, float dx, float dy, IBus bus) {
    setChannel(ch);
    this.x = x;
    this.y = y;
    this.rad = 10;   
    setDX(dx);
    setDY(dy);
    this.colour = col;
    setBus(bus);
    
  }
  
  int getId() { return getChannel(); }

  boolean outside(float n, int lim) {
    return ( (n < 0) || (n > lim) );
  }  

  boolean hit(Ball b) {
    return close(b.getX(), b.getY(), x, y, b.rad + rad); 
  }

  boolean hit(int ox, int oy) {
   return close(x,y,ox,oy,rad*2);
  }  
  
  public void interact(Iterable<IActor> blocks, Iterable<IMover> balls ) { 
    bounced = false;
    int tx=(int)(x+getDX());
    int ty=(int)(y+getDY());

    if (outside(tx,width)) { invDX(); bounced=true; }
    if (outside(ty,height)) { invDY(); bounced=true; }    
  
    for (IMover b : balls) {
      boolean flag1=false, flag2=false;
      if (!(b == this)) {
         if (b.hit(tx,getY())) {
           invDX();
           bounced=true;
           flag1=true;
         }
         if (b.hit(getX(),ty)) {
           invDY();
           bounced=true;
           flag2=true;
         }
         if (flag1 && (getDX() == b.getDX())) { setDX(-getDX()); }
         if (flag2 && (getDY() == b.getDY())) { setDY(-getDY()); }
      }      
    }  
  

    for (IActor b : blocks) {
      if (b.hit((int)(tx+getDX()),getY())) { 
        invDX(); 
        bounced=true;
      }
      if (b.hit(getX(),(int)(ty+getDY()))) {
        invDY();
        bounced=true;
      }
    } 

    x = tx;
    y = ty;
  }

  String toString() { 
    return "Ball " + getChannel() + " : " + x + ", " + y;  
  }
  
  void interact(Iterable<IMover> balls ) {
  }

  int getX() { return (int)x; }
  int getY() { return (int)y; }
  float fGetX() { return x; }
  float fGetY() { return y; }

  void draw() {
    fill(colour);
    ellipse(x,y,rad*2,rad*2);
  }

  void head_for(PVector target) {
    PVector vel = PVector.sub(target,new PVector(x,y));
    vel.normalize();
    vel.mult(5);
    setDX(vel.x);
    setDY(vel.y);
  }
  
  
  IBus innerBus;
  int channel;
  void postToBus() { 
    if (bounced) {
      IMessage m = new FloatMessage( map(getX(),0,width,0,1), map(getY(),0,height,1,0), 0, 0, 0, 0 );    
      innerBus.put(getChannel(),m);

      m = new BangMessage();
      innerBus.put(getChannel(),m);
    }
  }
  void setChannel(int c) { channel = c; }
  int  getChannel() { return channel; }
  void setBus(IBus b) { innerBus = b; }
  IBus getBus() { return innerBus; }


  String diagnostic() { return toString(); }  
}


class StickyBall extends Ball {
  boolean following = false;

  StickyBall(int c, color col, float x, float y, float dx, float dy, IBus bus) { super(c,col,x,y,dx,dy,bus); }
  
  void interact(Iterable<IMover> balls ) {
    if (following) { 
      setDX(other.getDX());
      setDY(other.getDY());      
      x=x+getDX();
      y=y+getDY();
    } else {
      x=x+getDX();
      y=y+getDY();

      if (outside(x,400)) { invDX(); }
      if (outside(y,400)) { invDY(); }
      
      for (IMover b2 : balls) {
        if (!(b2==this)) {
          if (PVector.sub(new PVector(b2.getX(),b2.getY()),new PVector(getX(),getY())).mag() < rad) {                      
            if (!((StickyBall)b2).following) {
              following = true;
              other = (Ball)b2;
            }
          }
        }
      }

    } 
    
  }
  
  
  void draw() {
    fill(colour);
    ellipse(x,y,10,10);
    line(x,y,width/2,height/2);
  }  
}


class StickyBalls extends BaseControlAutomaton implements IAutomatonToy {
  
  ArrayList<IMover> balls;

  int no_balls=10;
  PVector centre;
  PVector target;
  int counter;

  StickyBalls(ColorTool ct, IBus bus) {
    centre = new PVector(200,200);  
  
    balls = new ArrayList<IMover>();
    RandomColorGenerator rc = ct.randomColorGenerator(false);
    for (int i=0;i<no_balls;i++) {
      balls.add(new StickyBall(i,rc.next(),random(300)+100,random(300)+100,random(5)+5,random(5)+5, bus));
    }

  }

  void sizeInSetup() { size(400,400); }
  
  void nextStep() {
    for (IMover b : balls) {
      b.interact(balls);
    }    
  }
  
  void draw() {
    background(0);
    for (IMover b : balls) { 
      b.draw();
    }    
  }
  
  void mousePressed(int mouseX, int mouseY) {
    target = new PVector(mouseX,mouseY);
    
    for (int i=0;i<no_balls;i++) {
      Ball b = (Ball)balls.get(i);
      b.head_for(target);
    } 
  }
  void mouseReleased() { }

  void struck(int x, int y) { }
  void mouseDragged(int mouseX, int mouseY) { }
  void reset() {
    // TODO something
  } 
  void keyPressed(int k) { }
  
  String diagnostic() { return "StickyBalls"; }
  
  void postToBus() {
    // TODO something
  }
}



class GbloinkBlock extends BasicBlock {
  color c;
  
  GbloinkBlock(int x, int y, RandomColorGenerator randCols) {
    super(x,y);
    
    setWidth((int)(Math.random() * 100));
    setHeight((int)(Math.random() * 100));

    setX(x-getWidth()/2);
    setY(y-getHeight()/2);
    c = randCols.next();    
  }    
  
  void draw() {
    pushStyle();
    fill(c);
    stroke(255,255,255,255);
    rect(getX(),getY(),getWidth(),getHeight());
    popStyle();
  }
}

class GbloinkWorld extends BaseControlAutomaton implements IAutomatonToy, IBlockWorld {
  ArrayList<IMover> balls;
  BaseBlockWorld blocks; 

  int wide=800;
  int high=600;
   
  ColorTool ct;
  
  GbloinkWorld(IMover b1, IMover b2, IMover b3, ColorTool ct) {
    balls = new ArrayList<IMover>();
    balls.add(b1);
    balls.add(b2);
    balls.add(b3);
    this.ct = ct;
  }

  void reset() {    
    blocks = new BaseBlockWorld();
    for (int i=0;i<wide;i=i+50) {
      addBlock(new GbloinkBlock(i,(int)(50+Math.random()*100),colorTool.randomColorGenerator(true)));
      addBlock(new GbloinkBlock(i,(int)(high-100+Math.random()*100),colorTool.randomColorGenerator(true)));
    }
  }
  
  void nextStep() {
    for (IMover b : balls) {
      b.interact(blocks.itBlocks(),new IteratorCollection<IMover>(balls.iterator()));
    }
    
  }
  
  void draw() { 
    background(0);
    blocks.draw();
    for (IMover b : balls) { b.draw(); }  
  }
  
  void sizeInSetup() { }

  void addBlock(IActor block) { blocks.addBlock(block); }
  boolean blockSelected() { return blocks.blockSelected(); }
  IActor selectedBlock() throws NoSelectedBlockException { return blocks.selectedBlock(); }
  Iterable<IActor> itBlocks() { return blocks.itBlocks(); }

  void postToBus() {
    for (IMover b: balls) { ((IObservable)b).postToBus(); }     
  } 

  String diagnostic() { return "Gbloink! World with " + balls.size() + " balls"; } 

  void mousePressed(int x, int y) { struck(x,y); }
  void struck(int x, int y) {
     blocks.mousePressed(x,y);
     if (!(blocks.blockSelected())) {
       addBlock(new GbloinkBlock(x,y,colorTool.randomColorGenerator(true))); 
     }
  }
  void mouseReleased() { blocks.mouseReleased(); }  
  void mouseDragged(int mouseX, int mouseY) { blocks.mouseDragged(mouseX, mouseY); }

  void keyPressed(int k) { }
}

class ObInGbloink2ArtToys extends BaseObservingOSCInstrument {
    ObInGbloink2ArtToys(String ip, int port, String path, int chan, IFreqStrategy fs, IBus bus) {
      super(ip,port,path,chan,fs,bus);
    }
  
    OscMessage makeMessage(int bang, float[] xs) {
      float tone = makeCorrectedFreq(xs[0]);
      float filter =  map(xs[0],0,1,0,1000);
      return mFact.make(bang, tone, filter, xs[2],xs[3],xs[4]);
    }
}

class ObInGbloink2ArtToys2 extends BaseObservingOSCInstrument {
    ObInGbloink2ArtToys2(String ip, int port, String path, int chan, IFreqStrategy fs, IBus bus) {
      super(ip,port,path,chan,fs,bus);
    }
  
    OscMessage makeMessage(int bang, float[] xs) {
      float tone = makeCorrectedFreq(xs[1]);
      float filter =  map(xs[0],0,1,0,1000);
      return mFact.make(bang, tone, filter, xs[2],xs[3],xs[4]);
    }
}