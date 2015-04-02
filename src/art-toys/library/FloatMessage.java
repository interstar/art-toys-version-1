public class FloatMessage implements IMessage, IFloatMessage {
  float[] floats;
  FloatMessage(float f1, float f2, float f3, float f4, float f5, float f6) {    
    floats = new float[]{f1,f2,f3,f4,f5,f6};  
  }
  public String toString()  { 
    String s = "IMessage : ";
    for (int i=0;i<6;i++) { s = s + String.format("%.2f", floats[i]) + ", "; }
    return s;
  } 
  public boolean isBang() { return false; }
  public boolean isFloats() { return true; }
  public boolean isStrings() { return false; }
  
  public float[] getFloats() { return floats; }
}


