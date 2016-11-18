public class FrameTrack extends PApplet {
  KeyFrame[] frameTracks;
  float tHeight;
  public void settings() {
    size(800, 600);
  }
  public void draw() {
    background(255);
    if (mousePressed) {
      scrubber.loc = map(mouseX, 0, width, 0, );
    }
    for (int i = 0; i < frameTracks.length; i++) {
      rect(0, i * tHeight, width, (i + 1) * tHeight);
      frameTracks[i].draw(i);
      frameTracks[i].animate();
    }
  }
}