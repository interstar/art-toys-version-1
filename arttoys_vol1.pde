import java.util.Random;

IAutomatonToy toy;

Random rnd = new Random();;

CamHarp makeCamHarp() {
  CamHarp h = new CamHarp(this);
  //h.addObservingInstrument(new MinimObservingInstrument());
  
  OSCObservingInstrument[] ois = {new OSCObservingInstrument("127.0.0.1", 9004, "/channel0"),
                                  new OSCObservingInstrument("127.0.0.1", 9004, "/channel1"), 
                                  new OSCObservingInstrument("127.0.0.1", 9004, "/channel2"), 
                                  new OSCObservingInstrument("127.0.0.1", 9004, "/channel3")};
                                  
  int count=0;  
  for (Chime c : h.chimes) {    
    c.addObservingInstrument(ois[(int)(count/12)]);
    count++;
  }  
  return h;
}

void reset() {
  //toy = new KDiag(this,240,15,6);
  toy = (new ZewpFactory("bg.png",12,10)).makeWorld();
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
