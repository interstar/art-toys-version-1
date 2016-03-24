package arttoys.core;
import processing.core.*;

public class CyclingColor implements IColor {
    Cycler r,g,b,a;
    ColorTool ct;

    public void setup(ColorTool ct, double ir,double ig,double ib,double ia, double dr,double dg,double db,double da) {
        this.ct = ct;
        r = new Cycler(ir,dr,0,255);
        g = new Cycler(ig,dg,0,255);
        b = new Cycler(ib,db,0,255);
        a = new Cycler(ia,da,0,255);
    }

    public CyclingColor(ColorTool ct, double ir,double ig,double ib,double ia, double dr,double dg,double db,double da) {
        setup(ct, ir,ig,ib,ia,dr,dg,db,da);
    }

    public CyclingColor(ColorTool ct, double dr,double dg,double db,double da) {
        setup(ct, 0.0,0.0,0.0,0.0, dr,dg,db,da);
    }

    public int next() {
        return ct.color(r.next(),g.next(),b.next(),a.next());
    }
}
