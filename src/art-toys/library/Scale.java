package arttoys.core;

public class Scale {
    int[] scale;

    public Scale(int[] s) {  scale = s;  }

    public int transform(int note) {
      int n = note % 12;
      int c = 0;
      while (scale[(n+c)%12] == 0) { c = c + 1; }
      return note + c;
    }
}
