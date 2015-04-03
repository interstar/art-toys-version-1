import java.util.*;

public abstract class AbstractBaseBlockWorld extends BaseControlAutomaton implements IBlockWorld {
  ArrayList<IActor> _blocks;
  boolean _blockSelected;
  IActor _selectedBlock;

  IBus innerObservingBus;
  
  public void draw() {
    for (IActor b : itBlocks()) { b.draw(); }
  }
  
  public void addBlock(IActor block) { _blocks.add(block); }
  
  public Iterable<IActor> itBlocks() {
    return new IteratorCollection<IActor>(_blocks.iterator()); 
  }
  
  public void mousePressed(int mouseX, int mouseY) {
    for (IActor b : itBlocks()) {
      if (b.hit(mouseX,mouseY)) {
        _blockSelected=true;
        _selectedBlock=b;
        break;
      }
    }
  }

  public void mouseDragged(int mouseX, int mouseY) {
    if (blockSelected()) {
      IActor selected = _selectedBlock;
      selected.setX(mouseX-(selected.getWidth()/2));
      selected.setY(mouseY-(selected.getHeight()/2));   
    }  
  }
  
  public void mouseReleased() {
    _blockSelected = false;
  }

  public boolean blockSelected() {return _blockSelected; }
  
  public IActor selectedBlock() throws NoSelectedBlockException {
    if (!blockSelected()) { throw new NoSelectedBlockException(); }
    return _selectedBlock;
  }

  public void setBus(IBus bus) { innerObservingBus = bus; }
  public IBus getBus() { return innerObservingBus; }
  public void setChannel(int c)  {}
  public int  getChannel() { return 0; }
    
}

