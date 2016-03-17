package arttoys.core;


public class Mayhit<E> {
    E val;
    boolean hit;

    public Mayhit() { hit = false; }

    public Mayhit(E e) {
        hit = true;
        val = e;
    }

    public boolean isHit() {return hit;}

    public E value() throws NoHitException {
        if (hit) { return val; }
        throw new NoHitException();
    }
}
