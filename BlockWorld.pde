interface IBlockWorld extends IAutomatonToy {
  // blockworlds contain draggable / droppable blocks
  void mousePressed();
  void mouseDragged();
  void mouseReleased();
  
  boolean blockSelected();
  IActor selectedBlock() throws NoSelectedBlockException;
  Iterable<IActor> itBlocks();
  void addBlock(IActor block);
}


abstract class AbstractBaseBlockWorld extends BaseControlAutomaton implements IBlockWorld {
  ArrayList<IActor> _blocks;
  boolean _blockSelected;
  IActor _selectedBlock;

  IBus innerObservingBus;
  
  void draw() {
    for (IActor b : itBlocks()) { b.draw(); }
  }
  
  void addBlock(IActor block) { _blocks.add(block); }
  
  Iterable<IActor> itBlocks() {
    return new IteratorCollection<IActor>(_blocks.iterator()); 
  }
  
  void mousePressed() {
    for (IActor b : itBlocks()) {
      if (b.hit(mouseX,mouseY)) {
        _blockSelected=true;
        _selectedBlock=b;
        break;
      }
    }
  }

  void mouseDragged() {
    if (blockSelected()) {
      IActor selected = _selectedBlock;
      selected.setX(mouseX-(selected.getWidth()/2));
      selected.setY(mouseY-(selected.getHeight()/2));   
    }  
  }
  
  void mouseReleased() {
    _blockSelected = false;
  }

  boolean blockSelected() {return _blockSelected; }
  
  IActor selectedBlock() throws NoSelectedBlockException {
    if (!blockSelected()) { throw new NoSelectedBlockException(); }
    return _selectedBlock;
  }

  void setBus(IBus bus) { innerObservingBus = bus; }
  IBus getBus() { return innerObservingBus; }
  void setChannel(int c)  {}
  int  getChannel() { return 0; }
    
}

class BaseBlockWorld extends AbstractBaseBlockWorld {
  
  BaseBlockWorld() {
     _blocks = new ArrayList<IActor>();
  }
  // dummies because of interface
  void sizeInSetup(){}
  void struck(int x, int y) {}
  void reset(){}
  void nextStep(){}
  void keyPressed(int key) {}
  
  void postToBus() {}
  String diagnostic() { return "An instance of BaseBlockWorld"; }

}


interface IBlockWorldFactory {
  IBlockWorld makeWorld();
}

class NoSelectedBlockException extends Exception { }


abstract class BaseBlock extends BaseActor {
  
  boolean hit(int px, int py) {
    if (px < x) {return false;}
    if (px > x+wide) {return false;}
    if (py < y) {return false;}
    if (py > y+high) {return false;}
    return true;    
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
  //IColor col = new CyclingColor((float)Math.random()*255,255.0,255.0,255.0,1.0,0.47,0.0,0.0);  
  IColor col = new AColor(255,255,255,255);
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
    
    stroke(col.next());
    
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


