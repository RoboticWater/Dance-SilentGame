public class Scrubber {
  int loc;
  public Scrubber() {
    
  }
  public void draw() {
    FrameTrack ft = frameTrack;
    float x = map(loc, 0, songLen, 0, ft.width);
    ft.stroke(#FF0026);
    ft.strokeWeight(1);
    ft.line(x, 0, x, ft.height);
  }
}