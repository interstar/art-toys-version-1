public class BangMessage implements IMessage, IBangMessage {
  public boolean isBang() { return true; }
  public boolean isFloats() { return false; }
  public boolean isStrings() { return false; }
  public String toString() {  return "IMessage : BANG!"; }
}

