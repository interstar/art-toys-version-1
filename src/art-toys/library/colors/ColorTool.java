package arttoys.core.colors;

import processing.core.*;

public class ColorTool {

    PApplet pa;

    public ColorTool(PApplet parent) { pa=parent; }

    public int color(double r, double g, double b, double a) { return pa.color((int)r,(int)g,(int)b,(int)a); }
    public int color(double r, double g, double b) { return pa.color((int)r,(int)g,(int)b); }
    public int Color(double x) { return pa.color((int)x); }



    public AColor aColor(int r, int g, int b, int a) { return new AColor(this,r,g,b,a); }

    public CyclingColor cyclingColor(double ir,double ig,double ib,double ia,double dr,double dg,double db,double da) {
        return new CyclingColor(this,ir,ig,ib,ia,dr,dg,db,da);
    }

    public RandomColorGenerator randomColorGenerator(boolean a) {
        return new RandomColorGenerator(this,a);
    }
}
