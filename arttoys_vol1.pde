import java.util.Random;

IAutomatonToy toy;

Random rnd = new Random();;
IBus mainBus = new BasicBus();
ArrayList<IObservingOSCInstrument> instruments = new ArrayList<IObservingOSCInstrument>();

CamHarp makeCamHarp() {
  NoteCalculator nc = new NoteCalculator(); 
  nc.setCurrent("minor");
  IFreqStrategy fs = new ScaleBasedFreqStrategy(nc);  
  
  for (int i=0;i<4;i++) {
    instruments.add( new ObInCamMouse2ArtToys("localhost", 9004, "/channel"+i, i, fs, mainBus ) );    
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
  
  NoteCalculator nc = new NoteCalculator(); 
  nc.setCurrent("minor");
  IFreqStrategy fs = new ScaleBasedFreqStrategy(nc);  
  
  for (int i=0;i<6;i++) {
    Zewp z = new Zewp(i, i, rnd.nextInt(im.width),rnd.nextInt(im.height-20), 0, 10, 2, color(255,255,200), im.width, im.height, mainBus );
    zewps.add(z);
    instruments.add( new ObInZewp2ArtToys("localhost", 9004, "/channel"+i, i, fs, mainBus ) );
  }

  
  return new ZewpWorld(imgName,blocks,zewps,mainBus); 
}

void reset() {
  mainBus.reset();
  //toy = new KDiag(this,240,15,6,  new OSCObservingInstrument("192.168.0.131", 5001, "/a"));
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
