import java.util.Random;

IAutomatonToy toy;

Random rnd = new Random();;

CamHarp makeCamHarp() {
  CamHarp h = new CamHarp(this);
  return h;
}

void reset() {
  toy = new KDiag(this,240,15,6,  new OSCObservingInstrument("127.0.0.1", 9004, "/channel0"));
  //toy = (new ZewpFactory("bg.png",12,10)).makeWorld();
  //toy = makeCamHarp();
  toy.reset();
  toy.sizeInSetup();  
}
  

void setup() {
  reset();
}
 

void draw() {

  toy.nextStep();  
  toy.draw();
}

void mouseClicked() { toy.struck(mouseX,mouseY); }

void keyPressed() {
  if (key==' ') { reset(); return; } 
  toy.keyPressed(key); 
}

void mousePressed() { toy.mousePressed(); }
void mouseDragged() { toy.mouseDragged(); }
void mouseReleased() { toy.mouseReleased(); }
