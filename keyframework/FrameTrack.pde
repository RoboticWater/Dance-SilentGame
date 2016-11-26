public class FrameTrack extends PApplet {
  HashMap<Limb, KeyFrame> frameTracks;
  float tHeight;
  public void settings() {
    size(800, 600);
  }
  public void draw() {
    background(0);
    if (mousePressed) {
      scrubber.loc = round(map(mouseX, 0, width, 0, songLen) / beatLen) * beatLen;
      if (scrubber.loc < 0) scrubber.loc = 0;
      else if (scrubber.loc > songLen + 1) scrubber.loc = songLen;
    }
    int i = 0;
    for (Limb l : frameTracks.keySet()) {
      rectMode(LEFT);
      stroke(30);
      fill(50);
      strokeWeight(1.5);
      rect(-2, i * tHeight, width + 5, (i + 1) * tHeight);
      frameTracks.get(l).draw(i++);
      if (focusedLimb == null) frameTracks.get(l).animate(l, scrubber.loc);
    }
    scrubber.draw();
    float y = round((mouseY +  tHeight / 2) / tHeight) * tHeight;
    boolean h = mouseX > width - 15 - tHeight / 2;
    fill(h ? #FF0026 : 50);
    stroke(h ? 50 : #FF0026);
    strokeWeight(1.5);
    ellipse(width - 15, y - tHeight / 2, tHeight * 0.5, tHeight * 0.5);
    line(width - 15 - 3, y - tHeight / 2, width - 15 + 3, y - tHeight / 2);
    line(width - 15, y - 3 - tHeight / 2, width - 15, y - tHeight / 2 + 3);
  }
  void keyPressed() {
    if (key != ' ') return;
    for (Limb l : frameTracks.keySet()) {
      println(l.name + ": " + frameTracks.get(l));
    }
      println();
  }
  void mousePressed() {
    if (mouseX > width - 15 - tHeight / 2) {
      //frameTracks.get().add(scrubber.loc, 0);
    }
  }
}