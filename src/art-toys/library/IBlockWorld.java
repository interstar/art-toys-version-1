package arttoys.core;

public interface IBlockWorld extends IAutomatonToy {
  // blockworlds contain draggable / droppable blocks
  void mousePressed(int mouseX, int mouseY);
  void mouseDragged(int mouseX, int mouseY);
  void mouseReleased();

  boolean blockSelected();
  IActor selectedBlock() throws NoSelectedBlockException;
  Iterable<IActor> itBlocks();
  void addBlock(IActor block);
}
