package arttoys.core;

public class Scale {
    int[] scale;

    int transpose=0;

    public Scale(int[] s) {  scale = s;  }

    public int transform(int note) {
      int n = note % 12;
      int c = 0;
      while (scale[(n+c)%12] == 0) { c = c + 1; }
      return note + c + transpose;
    }

    public void setTranspose(int t) { transpose = t; }
    public int getTranspose() { return transpose; }
    public void shift(int x) { transpose = (transpose+x)%12; }
}
