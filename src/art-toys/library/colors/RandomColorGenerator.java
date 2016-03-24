package arttoys.core.colors;

import processing.core.*;
//import java.Math;

public class RandomColorGenerator implements IColor {
    boolean alpha;
    ColorTool ct;


    public RandomColorGenerator(ColorTool ct, boolean a) {
        this.ct = ct;
        alpha = a;
    }

    private int r(int lo, int hi) {
        return lo + (int)(Math.random() * ((hi - lo) + 1));
    }

    public int next() {
        int r,g,b;
        r = r(50,255);
        g = r(50,255);
        b = r(50,255);

        return ct.color(r,g,b);
    }
}
