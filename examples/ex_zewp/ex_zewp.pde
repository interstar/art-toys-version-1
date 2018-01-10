import arttoys.core.*;
import arttoys.core.colors.ColorTool;
import arttoys.core.colors.IColor;

import arttoys.core.music.INoteCalculator;
import arttoys.core.music.ChordNoteCalculator;
import arttoys.core.music.ScaleNoteCalculator;

import arttoys.core.music.IFreqStrategy;
import arttoys.core.music.NoteCalcBasedFreqStrategy;
import arttoys.core.music.IMusicObserver;

import arttoys.core.actors.IActor;
import arttoys.core.actors.BaseActor;

import java.util.Random;

IAutomatonToy toy;
Uids _ids = new Uids();
Random rnd = new Random();
IBus mainBus = new BasicBus();

ColorTool colorTool = new ColorTool(this);

IColor randCols = colorTool.randomColorGenerator(false); 

INoteCalculator nc = new ScaleNoteCalculator();
IFreqStrategy fs = new NoteCalcBasedFreqStrategy(nc);  

ArrayList<IObservingOSCInstrument> instruments = new ArrayList<IObservingOSCInstrument>();

ZewpWorld makeZewpWorld() {
  
  ArrayList<IActor> blocks = new ArrayList<IActor>();
  ArrayList<Zewp> zewps = new ArrayList<Zewp>();
  
  for (int i=0;i<12;i++) {
     IColor c = colorTool.cyclingColor((float)Math.random()*255,255.0,255.0,255.0,1.0,0.47,0.0,0.0);
     //c = colorTool.aColor(255,255,255,255);
     IActor b = new FlowerBlock(c,rnd.nextInt(width),rnd.nextInt(height-20));
     blocks.add(b);
  }
  
  nc.select("minor");
  
  for (int i=0;i<24  ;i++) {
    Zewp z = new Zewp(i, i, rnd.nextInt(width),rnd.nextInt(height-20), 0, 10, 2, color(255,255,200), width, height, mainBus );
    zewps.add(z);
    if (i % 2 == 0) {
      instruments.add( new ObInZewp2ArtToys("localhost", 9004, "/channel"+i, i, fs, mainBus ) );
    } else {
      instruments.add( new ObInZewp2ArtToys2("localhost", 9004, "/channel"+i, i, fs, mainBus ) );      
    }
  }

  
  return new ZewpWorld(blocks,zewps,mainBus); 
}



void reset() {
  mainBus.reset();
  toy = makeZewpWorld();
  toy.reset();
}
  

void setup() {
  size(800,600);
  reset();
  size(toy.getRecommendedWidth(),toy.getRecommendedHeight());
  stroke(color(200,200,30));
}
 

void draw() {
  mainBus.reset();
  toy.nextStep();  
  toy.draw();
  toy.postToBus();
  
  for (IObservingOSCInstrument in : instruments) {
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