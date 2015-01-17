import processing.video.*;

interface ICamouseUser {
  void drawVideo();
  void drawCursor();
  void camouseStep();
  PApplet getApp();
  
}

class Camouse {

  int numPixels;
  int[] previousFrame;
  int[] xs;
  int[] ys;

  int tx, ty;

  Capture video;
  PImage v2;

  Camouse(PApplet applet) {
    video = new Capture(applet, width, height);
    video.start(); 

    numPixels = video.width * video.height;

    previousFrame = new int[numPixels];
    xs = new int[numPixels];
    ys = new int[numPixels];
    loadPixels();
    v2 = mirror(video);
  }

  PImage mirror(Capture video) {
    PImage img = new PImage(width,height);
    img.loadPixels();
    for (int c = 0;c<width-1;c++) {
      for (int r = 0;r<height-1;r++) {
        img.pixels[r*width+c]=video.pixels[(r*width)+(width-c)];
      }
    }
    return img;
  }

  void draw() {
    if (video.available()) {
      println("video available");
      // When using video to manipulate the screen, use video.available() and
      // video.read() inside the draw() method so that it's safe to draw to the screen
      video.read(); // Read the new frame from the camera
      video.loadPixels(); // Make its pixels[] array available

      v2 = mirror(video);


      int movementSum = 0; // Amount of movement in the frame
      int changed=0;
      
      for (int i = 0; i < numPixels; i++) {
        color currColor = v2.pixels[i];
        color prevColor = previousFrame[i];

        int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
        int currG = (currColor >> 8) & 0xFF;
        int currB = currColor & 0xFF;
        // Extract red, green, and blue components from previous pixel
        int prevR = (prevColor >> 16) & 0xFF;
        int prevG = (prevColor >> 8) & 0xFF;
        int prevB = prevColor & 0xFF;
        // Compute the difference of the red, green, and blue values
        int diffR = abs(currR - prevR);
        int diffG = abs(currG - prevG);
        int diffB = abs(currB - prevB);


        int diff = (diffR + diffG + diffB);
        if (diff > 100) {         
          xs[changed] = i % width;
          ys[changed] = (int)i/width;
          changed=changed+1;
        }       
        previousFrame[i] = currColor;

        if (i==0) {
          println(i, currColor, prevColor, diff, xs[changed], ys[changed]);
        }
      }

      if (changed < 50) { return; }  
      tx=0;
      ty=0;
      for (int i=0; i<changed; i++) {
        tx = tx+xs[i];
        ty = ty+ys[i];
      }
      if (changed>0) {
        tx = tx/changed;
        ty = ty/changed;
      } else {
        tx = 0;
        ty = 0;
      }
    } else {
      println("no video");      
    }
  }

  int x() { return tx; }
  int y() { return ty; }
  
  PImage getVideo() { 
    return v2;
  }
}


