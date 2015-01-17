interface Mover extends Actor {
  void sendOSCMessage();
  void interact(ArrayList<Block> blocks, ArrayList<Mover> movers);

}

class Zewp extends BaseActor implements Mover {
    float a, da, dx, dy, len, vel, cos_a, sin_a;
    int colour;
    boolean alive;

    int app_width, app_height;
    OSCParam osc;

    int newNote;
    
    Zewp(int id, float x, float y, float a, float len, float vel, int colour, int app_width, int app_height) {
      setup(id,x,y,a,len,vel,colour,app_width,app_height);
    }

    void setup(int id, float x, float y, float a, float len, float vel, int colour, int app_width, int app_height) { 
      this.id = id; 
      this.x = x;
      this.y = y;
      this.a = a;
      this.len = len;
      this.vel = vel;
      this.colour = colour;
      this.app_width = app_width;
      this.app_height = app_height;
      alive=true;
      newNote=0;
      osc = new OSCParam("/channel"+this.id);
      
      if (rnd.nextInt(100) < 50) {
          da = PI / 12;
      } else {
          da = -PI/12;
      }      
    }
    
    void set_angle(float a) {
      this.a = a;
      cos_a = cos(a);
      sin_a = sin(a);
      dx = cos_a * vel;
      dy = sin_a * vel;
    }

    int getX() { return (int)x; }
    int getY() { return (int)y; }

    boolean look_ahead(ArrayList<Mover> zewps, ArrayList<Block> glyphs) {
      /* return true if something ahead, otherwise, false */  
      float px,py; // point we're testing
   
      px = x + (cos_a * (len));
      py = y + (sin_a * (len));

      for (int i=0; i<15; i++) {
        if (edge_in_front((int)px,(int)py,app_width,app_height)) {
            return true;
        }

        if (zewp_in_front((int)px,(int)py,zewps)) {
            return true;
        }

        if (glyph_in_front((int)px,(int)py,glyphs)) {
            return true;
        }

        px = px + dx/2;
        py = py + dy/2;
      }
      return false;
    }

    boolean edge_in_front(int x, int y, int app_width, int app_height) {
        if ((dx < 0) && (x < 5)) { return true; }
        if ((dy < 0) && (y < 5)) { return true; }
        if ((dx > 0) && (x > (app_width-5))) { return true; }
        if ((dy > 0) && (y > (app_height-5))) { return true; }
        return false;
    }

    boolean zewp_in_front(int px, int py, ArrayList<Mover> zewps) {
        for (int z=0;z<zewps.size();z++) {
            if (z == id) { continue; /* don't test for self */ }
            if (zewps.get(z).hit((int)px,(int)py)) {
                return true;
            }
        }
        return false;
    }


    boolean glyph_in_front(int x, int y, ArrayList<Block> glyphs) {
        for (int i=0; i<glyphs.size(); i++) {
            if (glyphs.get(i).hit((int)x,(int)y)) {
                return true;
            }
        }
        return false;
    }

    boolean hit(int px, int py) {
    
        PVector my_centre,  the_point, new_point;
    
        my_centre = new PVector(x,y);
        the_point = new PVector(px,py);
        new_point = new PVector(the_point.x, the_point.y);
        new_point.sub(my_centre);
        new_point.rotate(-a);
       
        // now see if it's in the zewp's rectangle
        if (new_point.x < -len) { return false; }
        if (new_point.x > len) { return false; }
        if (new_point.y < -4) { return false; }
        if (new_point.y > 4) { return false; }
        return true;
    }


  void interact(ArrayList<Block> blocks, ArrayList<Mover> movers) {
      if (!alive) { return; }
  
      boolean ahead = look_ahead(movers,blocks);
      if (!ahead) {
          x += dx;
          y += dy;
      } else {
          set_angle(a + da);
      }
  
      if ((x < 0) || (x > app_width)) { x = app_width/2; }
      if ((y < 0) || (y > app_height)) { y = app_height/2; }

      sendOSCMessage();    
  }      
  
  void draw() {
      pushMatrix();
        stroke(colour);
        strokeWeight(4);
        float x1, x2, y1, y2;
        x1 = x - cos_a * len;
        y1 = y - sin_a * len;
        x2 = x + cos_a * len;
        y2 = y + sin_a * len;
        line(x1,y1,x2,y2);
      popMatrix();      
  }
   
  float getFreq() { return height-(int)y; } 
  
  void sendOSCMessage() { 
      osc.send(newNote,getFreq(),getX(),getFreq());
      newNote=0;
  }
  
}

class Zewp2 extends Zewp {
  float freq;
  boolean n;

  Zewp2(int id, float x, float y, float a, float len, float vel, int colour, int app_width, int app_height) {
    super(id,x,y,a,len,vel,colour,app_width,app_height);
  }
  
  float getFreq() { return freq; }

  void sendOSCMessage() { 
      osc.send(newNote,getFreq(),getX(),getFreq());
      newNote=0;
  }


  boolean glyph_in_front(int x, int y, ArrayList<Block> glyphs) {
        for (int i=0; i<glyphs.size(); i++) {
            if (glyphs.get(i).hit((int)x,(int)y)) {
                freq = glyphs.get(i).getFreq();
                newNote=1;
                return true;
            }
        }
        return false;
  }


  boolean zewp_in_front(int px, int py, ArrayList<Mover> zewps) {
      for (int z=0;z<zewps.size();z++) {
          if (z == id) { continue; /* don't test for self */ }
          if (zewps.get(z).hit((int)px,(int)py)) {
                freq = zewps.get(z).getFreq();
                newNote=1;            
              return true;
          }
      }
      return false;
  }

}


class ZewpFactory implements IBlockWorldFactory {
  int noBlocks, noZewps;
  ZewpFactory(int noblocks, int nozewps) {
    noBlocks = noblocks;
    noZewps = nozewps;
  }
}

class ZewpWorld implements IControlAutomaton, IBlockWorld {

  ArrayList<Block> blocks;
  ArrayList<Mover> zewps;

  Block selectedBlock;
  boolean blockSelected;
  Random rnd;  
  
  int NoZewps;
  PImage backImg;

  ZewpWorld(String backImgName, int noZewps, int noBlocks) {
  
  }

}

