package arttoys.core;

import java.util.*;

public class IteratorCollection<E> implements Iterable<E> {
    private Iterator<E> it;

    public IteratorCollection(Iterator<E> it) { this.it = it;  }

    @Override
    public Iterator<E> iterator() { return it; }

}
