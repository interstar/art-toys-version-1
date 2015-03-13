// Array is [count, destination, length1, length2]
class Arc {
   int count, destination, len1, len2; 
  
  Arc(int c, int d, int l1, int l2) {
    count=c;
    destination=d;
    len1=l1;
    len2=l2;
  }
}

class EndOfSequenceException extends Exception {}

class Node extends BaseActor implements IActor, IObservable {  
  ArrayList<Arc> nexts;
  double a, rad;
  int currentWait, channel;
  
  IBus innerObservingBus;
  
  Node(double a, double rad) {
    makeUid();    
    nexts = new ArrayList<Arc>();
    currentWait=0;
    newPosition(a,rad);
    
  }
 
  void newPosition(double a, double rad) {
    this.a=a;
    this.rad=rad;
    x=(int)(Math.cos(a)*rad);
    y=(int)(Math.sin(a)*rad);
  }
  
  void addArc(int to, int l1, int l2) {
    nexts.add(new Arc(0,to,l1,l2));
  }

  int countTotalVisits() {
    int total = 0;
    for (Arc a : nexts) { total = total + a.count; }
    return total;
  }  
  
  int chooseNext() throws EndOfSequenceException {
    if (nexts.size() == 0) { throw new EndOfSequenceException(); }
    int[] inverts = new int[nexts.size()];
    int total = countTotalVisits();
    int i=0;
    int tot2=0;
    for (Arc a : nexts) { 
      inverts[i]=total - a.count;
      tot2=tot2+a.count;
      i++; 
    }
    int find = (int)(Math.random()*tot2);
    int tracker = 0;
    for (i=0;i<nexts.size();i++) {
      if (find < tracker + inverts[i]) {
        Arc a = nexts.get(i);
        currentWait = a.len1; 
        return a.destination; 
      }
      tracker=tracker+inverts[i];
    }
    Arc a = nexts.get(i-1);
    currentWait = a.len1; 
    return a.destination; 
  }

  void updateCounter(int dest) {
    for (Arc a : nexts) {
      if (a.destination == dest) { a.count++;  return; }
    }
  }

  void rotate(float da) {
    newPosition(a+da,rad);
  }

  // UI

  boolean hit(int ox, int oy) {
    int dx = (int)Math.abs(x-ox);
    int dy = (int)Math.abs(y-oy);
    if ( (dx<20) && (dy<20)) { return true; }
    return false;    
  }
  
  void draw() {
    pushStyle();
    fill(150,200,210);      
    ellipse(x,y,20,20);
    popStyle();    
  }
  
  void drawHighlighted() {
    pushStyle();
    fill(200,0,100);      
    ellipse(x,y,20,20);
    popStyle();    
  }  

  float getFreq() { return map(getY(),-320,320,1000,0); }

  void setChannel(int c) { channel = c; }
  int  getChannel() { return channel; }
  void postToBus() { // fill me
  
  }
  
  void setBus(IBus bus) { innerObservingBus = bus; }
  IBus getBus() { return innerObservingBus; }
  String diagnostic() { return "A Node at " + getX() + ", " + getY(); }  
  
  
} 


class Network extends BaseBlockWorld implements IBlockWorld {
  
  int rad;
  int currentWait;
  
  Network(int aRad, int noNodes, int arcsPerNode) {
    rad = aRad;
    // random initializer
    for (int i=0;i<noNodes;i++) {
      double a = Math.random() * PI * 2;
      int r = (int)(0.2 + (0.8 * Math.random() * rad));     
      Node n = new Node(Math.random()*2*PI,rad/3 + (Math.random()*2*rad/3));      
      for (int j=0;j<(int)(Math.random()*arcsPerNode);j++) {
        int k = i;
        while (k==i) {
          k = (int)(Math.random()*noNodes);
        }
        n.addArc(k,(int)(Math.random()*50),(int)(Math.random()*50));
      }
      addBlock(n);
    }
  }
  
  void draw() {
    pushMatrix();
    translate(320,240);
    for (IActor an : itBlocks()) {
      Node n = (Node)an;
      n.draw();
      for (Arc a : n.nexts) {
        stroke(255,200,100);
        Node dest = (Node)(_blocks.get(a.destination));
        line(n.getX(),n.getY(),dest.getX(),dest.getY());
        int hx = (n.getX() + (int)((dest.getX()-n.getX())*0.9));
        int hy = (n.getY() + (int)((dest.getY()-n.getY())*0.9));
        ellipse(hx,hy,5,5);
        
        noStroke();
      }
    }
    noFill();
    stroke(200,200,100);
    ellipse(0,0,rad*2,rad*2);
    popMatrix();
  }
  

  int nextFrom(int from) throws EndOfSequenceException {
    Node node = (Node)(_blocks.get(from));    
    int dest = node.chooseNext();    
    node.updateCounter(dest);
    currentWait = node.currentWait;
    return dest;
  }
  
  int selected(int x, int y, int xOffset, int yOffset) {
    int i=0;
    for (IActor n : itBlocks()) {
      if (n.hit(x-xOffset,y-yOffset)) { return i; }
      i++;
    }
    return -1;   
  }

  Node getNode(int i) { return (Node)_blocks.get(i); }
 
  void rotate(float da) {
    for (IActor n : itBlocks()) { ((Node)n).rotate(da); }
  }
 
  
}

interface IHasNetwork {
  void recreateNetwork(int aRad, int noNodes, int arcsPerNode);
  Network getNetwork();
  int selected(int x, int y, int xOffset, int yOffset);
}

class KDiag extends BaseControlAutomaton implements IAutomatonToy, ICamouseUser, IHasNetwork, IBlockWorld {    
  Network network;

  int currentNode; 
  int wait = 20;
  
  Camouse camouse;
  PApplet pa;
  
  KDiag(PApplet pa, int aRad, int noNodes, int arcsPerNode, int chan, IBus bus) {
    this.pa = pa;
    sizeInSetup();
    setBus(bus);
    setChannel(chan);

    camouse = new Camouse(pa,bus); 
    recreateNetwork(aRad,noNodes,arcsPerNode);
    
  }
  
  Network getNetwork() { return network; }
  
  int selected(int x, int y, int xOffset, int yOffset) { 
    int find = network.selected(x,y,xOffset,yOffset);
    if (find > -1) { currentNode = find; } 
    return find;
  }

  void recreateNetwork(int aRad, int noNodes, int arcsPerNode) { 
    network = new Network(aRad,noNodes,arcsPerNode);
    currentNode = 0;         
  }
 
  Node getCurrentNode() { return network.getNode(currentNode); }
  
  
  void nextStep() {
    camouseStep();
    if (!isPlaying()) { return; }
    if (frameCount % (1+wait) == 0) { 
      try {
        currentNode = network.nextFrom(currentNode);
        wait = network.currentWait*5;
        playEvent(getCurrentNode());
      } catch (EndOfSequenceException e) {
        currentNode = 0;
        stop();      
        wait = 20;
      }   
    }    
  }
  
  void playEvent(Node n) {  
    IMessage m = new FloatMessage( map(n.getX(),-width/2,width/2,0,1), map(n.getY(),height/2,-height/2,1,0), 0, 0, 0, 0);
    innerObservingBus.put(getChannel(),m);
    m = new BangMessage();
    innerObservingBus.put(getChannel(),m);
  }
  
  void draw() {    
    drawVideo();
    network.draw();
    Node cNode = (Node)(network._blocks.get(currentNode));
    pushMatrix();
      translate(320,240);
      cNode.drawHighlighted();
    popMatrix();
    drawCursor(); 
  }

  void struck(int x, int y) {
    int find = selected(x,y,320,240);
    
    if (find > -1) { 
      start();
      playEvent(network.getNode(find));
    }  
  }


  void keyPressed(int k) {
    switch (k) {
      case 32 : reset();
        return;
      case 91 : getNetwork().rotate(-0.01);
        return;
      case 93 : getNetwork().rotate(0.01);
        return;    
    } 
  }

  void sizeInSetup() {
    size(640,480);  
  }

  void drawVideo() {
    camouse.draw();
    image(camouse.getVideo(), 0, 0);
  }

  void reset() {
    recreateNetwork(240, 15 ,6);       
  }

  void camouseStep() {
      struck(camouse.x(),camouse.y());      
  }

  void drawCursor() {
      stroke(255);
      fill(100,100,255,200);    
      ellipse(camouse.x(), camouse.y(), 10, 10);
  }

  PApplet getApp() { return pa; }
  
  boolean blockSelected() { return network.blockSelected(); }
  void mousePressed() { network.mousePressed(); }
  void mouseReleased() { network.mouseReleased(); }  
  void mouseDragged() { network.mouseDragged(); }
  IActor selectedBlock() throws NoSelectedBlockException { return network.selectedBlock(); }
  
  void addBlock(IActor b) {network.addBlock(b); }
  Iterable<IActor> itBlocks() { return network.itBlocks(); }

  void postToBus() { 
// TODO ... fill me
  }

  String diagnostic() { return "KDiag"; }  
}
 
  


class ObInKDiag2ArtToys extends BaseObservingOSCInstrument {
    ObInKDiag2ArtToys(String ip, int port, String path, int chan, IFreqStrategy fs, IBus bus) {
      super(ip,port,path,chan,fs,bus);
    }
  
    OscMessage makeMessage(int bang, float[] xs) {
      float tone = makeCorrectedFreq(xs[1]);
      float filter =  map(xs[0],0,1,0,1000);
      return mFact.make(bang, tone, filter, xs[2],xs[3],xs[4]);
    }
}

