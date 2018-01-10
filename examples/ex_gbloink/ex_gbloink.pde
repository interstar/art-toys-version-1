import arttoys.core.*;
import arttoys.core.colors.ColorTool;
import arttoys.core.colors.IColor;
import arttoys.core.colors.RandomColorGenerator;

import arttoys.core.music.INoteCalculator;
import arttoys.core.music.ScaleNoteCalculator;
import arttoys.core.music.IFreqStrategy;
import arttoys.core.music.NoteCalcBasedFreqStrategy;
import arttoys.core.music.IMusicObserver;

import arttoys.core.actors.IMover;

import java.util.Random;

IAutomatonToy toy;
Uids _ids = new Uids();
Random rnd = new Random();
IBus mainBus = new BasicBus();

ColorTool colorTool = new ColorTool(this);

INoteCalculator nc = new ScaleNoteCalculator();
IFreqStrategy fs = new NoteCalcBasedFreqStrategy(nc);  

ArrayList<IObservingOSCInstrument> instruments = new ArrayList<IObservingOSCInstrument>();

GbloinkWorld makeGbloink() {
  nc.select("minor");
  for (int i=0;i<3;i++) {
    instruments.add( new ObInGbloink2ArtToys2("localhost", 9004, "/channel"+i, i, fs, mainBus ) );
  }

  return new GbloinkWorld(new Ball(0,color(255,0,0),random(300)+100,random(300)+100,2,2, mainBus),
                          new Ball(1,color(0,255,0),random(300)+100,random(300)+100,2,2, mainBus),
                          new Ball(2,color(0,0,255),random(300)+100,random(300)+100,2,2, mainBus),
                          colorTool
                          
  );
}

void reset() {
  mainBus.reset();
  toy = makeGbloink();
  toy.reset();
}
  

void setup() {
  size(800,600);
  reset();
  stroke(color(200,200,30));
}
 

void draw() {
  mainBus.reset();
  toy.nextStep();  
  toy.draw();
  toy.postToBus();

  
  for (IObservingOSCInstrument in : instruments) {
    //println(in.getClass().getName());
    in.scanBus();
  }

}

void mouseClicked() { toy.struck(mouseX,mouseY); }

void keyPressed() {
  if (key==' ') { reset(); return; }
  toy.keyPressed(key); 
  nc.keyPressedControl(key);
}

void mousePressed() { toy.mousePressed(mouseX, mouseY); }
void mouseDragged() { toy.mouseDragged(mouseX, mouseY); }
void mouseReleased() { toy.mouseReleased(); }