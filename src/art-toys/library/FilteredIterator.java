package arttoys.core;

import java.util.*;

public class FilteredIterator<E> implements Iterator<E> {
  // I Hate Java and the lack of anything useful like lazy lists / generators / yield etc.
  ArrayList<E> inner = new ArrayList<E>();
  Iterator<E> it;

  public FilteredIterator(IteratorCollection<E> stream, FilterTest<E> test) {
    for (E e : stream) { if (test.matches(e)) { inner.add(e); } }
    it = inner.iterator();
  }

  public boolean hasNext() { return it.hasNext();  }
  public E next() { return it.next(); }
  public void remove() { }
}
