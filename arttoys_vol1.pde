
Camouse camouse;
IControlAutomaton toy;

void setup() {
  toy = new  KDiag(240,15,6);
  toy.reset();
  
  toy.sizeInSetup();
  frameRate(20);
   
  toy.addObservingInstrument(new MinimObservingInstrument());
  toy.addObservingInstrument(new OSCObservingInstrument());  

  camouse = new Camouse(this); 
}
 

void draw() {
  camouse.draw();
  image(camouse.getVideo(), 0, 0);

  toy.nextStep();  
  toy.draw();

  stroke(255);
  ellipse(camouse.x(), camouse.y(), 10, 10);
  
  toy.struck(camouse.x(), camouse.y());
}

void mouseClicked() { toy.struck(mouseX,mouseY); }

void keyPressed() { toy.keyPressed(key); }
