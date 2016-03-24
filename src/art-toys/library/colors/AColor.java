package arttoys.core;

import processing.core.*;

public class AColor implements IColor {
    int col;
    public AColor(ColorTool ct, int r, int g, int b, int a) { col = ct.color(r,g,b,a); }
    public int next() { return col; }
}
