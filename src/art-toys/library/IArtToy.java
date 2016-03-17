package arttoys.core;

public interface IArtToy extends IUIListener, IObservable   {
  void reset();
  void sizeInSetup();

  void nextStep();
  void draw();

}
