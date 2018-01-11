
import arttoys.core.actors.BaseBlock;

class BasicBlock extends BaseBlock {

  BasicBlock(int x, int y) {
    makeUid(_ids);
    
    setWidth(50);
    setHeight(50);

    setX(x);
    setY(y);    
  }  
  
  void draw() {
    pushStyle();
    fill(200,200,200,100);
    stroke(255,255,255,255);
    rect(getX(),getY(),getWidth(),getHeight());
    popStyle();
  } 
  
}

class FlowerBlock extends BaseBlock {
  float sa=PI/5;
   
  IColor col;
  FlowerBlock(IColor col, int x, int y) {
    this.col = col;
    makeUid(_ids);
    setWidth(70);
    setHeight(70);
    setX(x);
    setY(y);
  }
  
  void draw() {
    float w2 = getWidth()/2;
    float hx = getHeight()*1.5;
    pushStyle();
    pushMatrix();
    strokeWeight(2);
    fill(200,200,200,100);
    
    stroke(col.next());
    
    translate(getX()+getWidth()/2,getY()+getHeight()/2);
    
    for (int i=0;i<8;i++) {
      curve(-getWidth(),hx, -w2,0,0,0,-getWidth(),hx);
      curve(-getWidth(),-hx,-w2,0,0,0,-getWidth(),-hx);
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
    makeUid(_ids);    
    img = loadImage(name);
    setWidth(img.width);
    setHeight(img.height);

    setX(x);
    setY(y);    
  }



  void draw() {
    image(img,x,y);
  }

}


