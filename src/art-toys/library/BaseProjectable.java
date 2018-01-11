package arttoys.core;

import processing.core.*;

public abstract class BaseProjectable implements IProjectable {
  protected boolean transforming;
  protected float o_x1, o_y1, o_x2, o_y2;
  protected PVector top_left, top_right, bottom_right, bottom_left;
  protected LineHelper line_helper;

  public void set_transform(float o_x1, float o_y1, float o_x2, float o_y2, PVector tl, PVector tr, PVector br, PVector bl) {
    this.o_x1 = o_x1;
    this.o_y1 = o_y1;
    this.o_x2 = o_x2;
    this.o_y2 = o_y2;

    top_left = tl;
    top_right = tr;
    bottom_right = br;
    bottom_left = bl;
    transforming = true;
  }

  float trans(float n, float lo1, float hi1, float lo2, float hi2) {
    return ((n/(hi1-lo1)) * (hi2-lo2))+lo2;
  }

  public boolean isTransforming() { return transforming; }

  class LineHelper {
    /* Handy line geometry functions */
    float gradient(PVector start, PVector end) {
      return (end.y - start.y) / (end.x - start.x);
    }

    float offset(PVector start, float grad) {
      return start.y - (grad * start.x);
    }


    PVector intersect(PVector line1_start, PVector line1_end, PVector line2_start, PVector line2_end) {
      float m1, a1, m2, a2;
      m1 = gradient(line1_start, line1_end);
      a1 = offset(line1_start, m1);
      m2 = gradient(line2_start, line2_end);
      a2 = offset(line2_start, m2);
      float x = (a2-a1)/(m1-m2);
      float y = m1*x + a1;
      return new PVector(x,y);
    }
  }



  public PVector trans(PVector invect) {
    if (!isTransforming()) {
      return invect;
    } // don't transform if a transform space hasn't been set up

    // x and y as proportion of overall width and height
    float x_r, y_r;
    x_r = (invect.x-o_x1) / (o_x2-o_x1);
    y_r = (invect.y-o_y1) / (o_y2-o_y1);

    // find unit vectors for each side
    PVector top = PVector.sub(top_right,top_left);
    PVector right = PVector.sub(bottom_right,top_right);
    PVector bottom = PVector.sub(bottom_right, bottom_left);
    PVector left = PVector.sub(bottom_left, top_left);

    float top_length = top.mag();
    top.normalize();
    top.mult(top_length*x_r);

    float right_length = right.mag();
    right.normalize();
    right.mult(right_length * y_r);

    float bottom_length = bottom.mag();
    bottom.normalize();
    bottom.mult(bottom_length * x_r);

    float left_length = left.mag();
    left.normalize();
    left.mult(left_length * y_r);


    // now find actual mid-points
    PVector mid_top = new PVector(top_left.x, top_left.y);
    mid_top.add(top);

    PVector mid_right = new PVector(top_right.x, top_right.y);
    mid_right.add(right);

    PVector mid_bottom = new PVector(bottom_left.x, bottom_left.y);
    mid_bottom.add(bottom);

    PVector mid_left = new PVector(top_left.x, top_left.y);
    mid_left.add(left);

    // now we have the x_r and y_r  proportioned points on all the sides. Need to find where the two transversals cross
    /*
    if (draw_boundaries) {
      strokeWeight(1);
      stroke(255);
      line(mid_left.x,mid_left.y, mid_right.x,mid_right.y);
      line(mid_top.x,mid_top.y, mid_bottom.x, mid_bottom.y);
    }
    */
    return line_helper.intersect(mid_left,mid_right,mid_top,mid_bottom);
  }

  public abstract void draw();
}
