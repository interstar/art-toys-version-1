import processing.core.*;

interface IProjectable {
   void set_transform(float o_x1, float o_y1, float o_x2, float o_y2, PVector tl, PVector tr, PVector br, PVector bl);
   PVector trans(PVector invect);
   boolean isTransforming();
   void draw();
}
