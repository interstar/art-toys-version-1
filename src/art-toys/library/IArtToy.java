package arttoys.core;

public interface IArtToy extends IUIListener, IObservable   {
  void reset();

  void nextStep();
  void draw();

  int getRecommendedWidth();
  int getRecommendedHeight();
}
