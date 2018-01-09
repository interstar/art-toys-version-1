package arttoys.core;

import java.util.*;
import arttoys.core.actors.IActor;

public class BaseBlockWorld extends AbstractBaseBlockWorld {

  public BaseBlockWorld() {
     _blocks = new ArrayList<IActor>();
  }
  // dummies because of interface

  public int getRecommendedWidth() { return 100; }
  public int getRecommendedHeight() { return 100; }
  public void struck(int x, int y) {}
  public void reset(){}
  public void nextStep(){}
  public void keyPressed(int key) {}

  public void postToBus() {}
  public String diagnostic() { return "An instance of BaseBlockWorld"; }

}
