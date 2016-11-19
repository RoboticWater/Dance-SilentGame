public class FrameTrack extends PApplet {
  HashMap<Limb, KeyFrame> frameTracks;
  float tHeight;
  public void settings() {
    size(800, 600);
  }
  public void draw() {
    background(255);
    if (mousePressed) {
      scrubber.loc = round(map(mouseX, 0, width, 0, songLen) / beatLen) * beatLen;
      if (scrubber.loc < 0) scrubber.loc = 0;
      else if (scrubber.loc > songLen + 1) scrubber.loc = songLen;
    }
    int i = 0;
    for (Limb l : frameTracks.keySet()) {
      rectMode(LEFT);
      stroke(0);
      fill(255);
      rect(0, i * tHeight, width, (i + 1) * tHeight);
      frameTracks.get(l).draw(i++);
      if (focusedLimb == null) frameTracks.get(l).animate(l, scrubber.loc);
    }
    scrubber.draw();
  }
  void keyPressed() {
    if (key != ' ') return;
    for (Limb l : frameTracks.keySet()) {
      println(l.name + ": " + frameTracks.get(l));
    }
      println();
  }
}