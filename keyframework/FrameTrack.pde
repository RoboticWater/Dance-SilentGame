public class FrameTrack extends PApplet {
  KeyFrame[] frameTracks;
  float tHeight;
  public void settings() {
    size(800, 600);
  }
  public void draw() {
    background(255);
    if (mousePressed) {
      scrubber.loc = round(map(mouseX, 0, width, 0, songLen) / beatLen) * beatLen;
    }
    for (int i = 0; i < frameTracks.length; i++) {
      rectMode(LEFT);
      stroke(0);
      fill(255);
      rect(0, i * tHeight, width, (i + 1) * tHeight);
      frameTracks[i].draw(i);
      if (doAnim) frameTracks[i].animate(scrubber.loc);
    }
    scrubber.draw();
  }
}