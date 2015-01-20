import java.util.Random;

IArtAndMusic toy;

Random rnd = new Random();;

void reset() {
  //toy = new KDiag(this,240,15,6);
  //toy = (new ZewpFactory("bg.png",12,10)).makeWorld();
  toy = new CamHarp(this);
  toy.reset();
  toy.sizeInSetup();  
  toy.addObservingInstrument(new MinimObservingInstrument());
  //toy.addObservingInstrument(new OSCObservingInstrument("127.0.0.1",9004,"/channel0"));  
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
