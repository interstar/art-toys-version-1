interface IBlockWorld extends IControlAutomaton {
  
}

interface IBlockWorldFactory {
  IBlockWorld makeWorld();
}


interface Block extends Actor {
  void setX(int x);
  void setY(int y);
}  

abstract class BaseBlock extends BaseActor implements Block {
  
  boolean hit(int px, int py) {
    if (px < x) {return false;}
    if (px > x+wide) {return false;}
    if (py < y) {return false;}
    if (py > y+high) {return false;}
    return true;    
  }  

  float getFreq() {
    return height-y; 
  }

  void setX(int x) { this.x = x; }
  void setY(int y) { this.y = y; }
 
  abstract void draw(); 
}

class BasicBlock extends BaseBlock {

  BasicBlock(int x, int y) {
    makeUid();
    
    wide = 50;
    high = 50;

    setX(x);
    setY(y);    
  }  
  
  void draw() {
    pushStyle();
    fill(200,200,200,100);
    stroke(255,255,255,255);
    rect(getX(),getY(),wide,high);
    popStyle();
  }
  
}

class FlowerBlock extends BaseBlock {
  float sa=PI/5;
  CyclingColor col = new CyclingColor(1,0,0,0);
  
  FlowerBlock(int x, int y) {
    makeUid();
    wide = 70;
    high = 70;
    setX(x);
    setY(y);
  }
  
  void draw() {
    float w2 = wide/2;
    float hx = high*1.5;
    pushStyle();
    pushMatrix();
    strokeWeight(2);
    fill(200,200,200,100);
    
    stroke(col);
    col.next();
    
    //stroke(rc,255,255,255);
    rc=rc+drc;
    if (rc>255) {drc=-1;}
    if (rc<0) {drc=1;}
    translate(getX()+wide/2,getY()+high/2);
    
    for (int i=0;i<8;i++) {
      curve(-wide,hx, -w2,0,0,0,-wide,hx);
      curve(-wide,-hx,-w2,0,0,0,-wide,-hx);
      rotate(PI/4);
    }
    
    popMatrix();
    popStyle();
  }
  
}

class Glyph extends BaseBlock {
  public PImage img;
 
  Glyph(String name, int x, int y) { setup(name,x,y); }
  
  void setup(String name, int x, int y) {
    makeUid();    
    img = loadImage(name);
    wide = img.width;
    high = img.height;

    setX(x);
    setY(y);    
  }



  void draw() {
    image(img,x,y);
  }

}

NoteCalculator noteCalculator = new NoteCalculator();

class TunedGlyph extends Glyph {
  
  TunedGlyph(String name, int x, int y) {
   super(name,x,y);    
  }

  float getFreq() { return (float)noteCalculator.heightToFreq((int)y,height); }
}
