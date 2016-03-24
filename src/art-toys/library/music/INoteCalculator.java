package arttoys.core.music;

public interface INoteCalculator {
    double valToMidi(float v);
    double valToFreq(float v);
    void keyPressedControl(int k);

    void select(String selector);
    String selectedName();

    void setTranspose(int t);
    int getTranspose();
    int shiftTranspose(int dt);

}
