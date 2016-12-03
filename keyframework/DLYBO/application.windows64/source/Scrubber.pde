public class Scrubber {
  int loc;
  public Scrubber() {
    
  }
  public void draw() {
    float x = map(loc, exerptOff, exerptOff + exerptLen, width / 2, width);
    stroke(#FF0026);
    strokeWeight(1);
    line(x, 0, x, height);
  }
}