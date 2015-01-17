import java.util.Random;

IArtToy toy;

IBlockWorldFactory fac = new ZewpFactory("bg.png",12,10);

Random rnd = new Random();;


void setup() {
  toy = new KDiag(this,240,15,6);
  //toy = fac.makeWorld();
  //toy = new CamHarp(this);
  toy.reset();
  
  toy.sizeInSetup();

   
  toy.addObservingInstrument(new MinimObservingInstrument());
  toy.addObservingInstrument(new OSCObservingInstrument());  

}
 

void draw() {

  toy.nextStep();  
  toy.draw();
}

void mouseClicked() { toy.struck(mouseX,mouseY); }

void keyPressed() { toy.keyPressed(key); }
