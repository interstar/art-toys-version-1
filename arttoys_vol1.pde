import java.util.Random;

IAutomatonToy toy;

Random rnd = new Random();;
IBus mainBus = new BasicBus();

NoteCalculator nc = new NoteCalculator();
IFreqStrategy fs = new ScaleBasedFreqStrategy(nc);  

ArrayList<IObservingOSCInstrument> instruments = new ArrayList<IObservingOSCInstrument>();


CamHarp makeCamHarp() {
   
  nc.setCurrent("gypsy");
  
  for (int i=0;i<4;i++) {
    instruments.add( new ObInCamHarp2ArtToys("localhost", 9004, "/channel"+i, i, fs, mainBus ) );    
  }
  
  CamHarp h = new CamHarp(this,mainBus);
  return h;
}

ZewpWorld makeZewpWorld() {
  String imgName = "bg.png";
  
  PImage im = loadImage(imgName);
  
  ArrayList<IActor> blocks = new ArrayList<IActor>();
  ArrayList<Zewp> zewps = new ArrayList<Zewp>();
  
  for (int i=0;i<12;i++) {
     IActor b = new FlowerBlock(rnd.nextInt(im.width),rnd.nextInt(im.height-20));
     blocks.add(b);
  }
  
  nc.setCurrent("minor");
  
  for (int i=0;i<6;i++) {
    Zewp z = new Zewp(i, i, rnd.nextInt(im.width),rnd.nextInt(im.height-20), 0, 10, 2, color(255,255,200), im.width, im.height, mainBus );
    zewps.add(z);
    if (i % 2 == 0) {
      instruments.add( new ObInZewp2ArtToys("localhost", 9004, "/channel"+i, i, fs, mainBus ) );
    } else {
      instruments.add( new ObInZewp2ArtToys2("localhost", 9004, "/channel"+i, i, fs, mainBus ) );      
    }
  }

  
  return new ZewpWorld(imgName,blocks,zewps,mainBus); 
}

KDiag makeKDiag() {
  IFreqStrategy fs = new UncertainY(height,20);
  nc.setCurrent("major");
  
  instruments.add( new ObInKDiag2ArtToys("localhost", 9004, "/channel0", 0, fs, mainBus) );
  return new KDiag(this, 240,15,6, 0, mainBus);
}

void reset() {
  mainBus.reset();
  //toy = makeKDiag();
  toy = makeZewpWorld();
  //toy = makeCamHarp();
  toy.reset();
  toy.sizeInSetup();  
}
  

void setup() {
  reset();
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
  toy.keyPressed(key); 
}

void mousePressed() { toy.mousePressed(); }
void mouseDragged() { toy.mouseDragged(); }
void mouseReleased() { toy.mouseReleased(); }
