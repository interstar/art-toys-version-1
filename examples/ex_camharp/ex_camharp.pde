import arttoys.core.*;
import arttoys.core.colors.ColorTool;
import arttoys.core.colors.IColor;

import arttoys.core.music.INoteCalculator;
import arttoys.core.music.ChordNoteCalculator;
import arttoys.core.music.IFreqStrategy;
import arttoys.core.music.NoteCalcBasedFreqStrategy;
import arttoys.core.music.IMusicObserver;

import java.util.Random;

IAutomatonToy toy;
Uids _ids = new Uids();
Random rnd = new Random();
IBus mainBus = new BasicBus();

ColorTool colorTool = new ColorTool(this);

INoteCalculator nc = new ChordNoteCalculator();
IFreqStrategy fs = new NoteCalcBasedFreqStrategy(nc);  

ArrayList<IObservingOSCInstrument> instruments = new ArrayList<IObservingOSCInstrument>();


CamHarp makeCamHarp() {
   
  nc.select("I");
  
  for (int i=0;i<4;i++) {
    instruments.add( new ObInCamHarp2ArtToys("localhost", 9004, "/channel"+i, i, fs, mainBus ) );    
  }
  
  CamHarp h = new CamHarp(this,mainBus);
  return h;
}



void reset() {
  mainBus.reset();
  toy = makeCamHarp();
  
  toy.reset();

}
  

void setup() {
  size(640,480);
  reset();
  stroke(color(200,200,30));
}
 

void draw() {
  mainBus.reset();
  toy.nextStep();  
  toy.draw();
  toy.postToBus();
  //println(mainBus.diagnostic());
  
  for (IObservingOSCInstrument in : instruments) {
    //println(in.getClass().getName());
    in.scanBus();
  }    
}

void mouseClicked() { toy.struck(mouseX,mouseY); }

void keyPressed() {
  if (key==' ') { reset(); return; }
  nc.keyPressedControl(key); 
  toy.keyPressed(key); 
}

void mousePressed() { toy.mousePressed(mouseX, mouseY); }
void mouseDragged() { toy.mouseDragged(mouseX, mouseY); }
void mouseReleased() { toy.mouseReleased(); }