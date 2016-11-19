public class Scrubber {
  int loc;
  public Scrubber() {
    
  }
  public void draw() {
    frameTrack.stroke(#ff1111);
    frameTrack.strokeWeight(1);
    frameTrack.line(map(loc, 0, songLen, 0, frameTrack.width),
                        0, map(loc, 0, songLen, 0, frameTrack.width), frameTrack.height);
  }
}