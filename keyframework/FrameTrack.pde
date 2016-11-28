public void frameTrack() {
  if (mousePressed && ((mouseX >= width / 2 && mouseX <= width - trackHeight * 0.5 - 15) || scrubFocus) && focusedLimb == null) {
    scrubFocus = true;
    doAnim = false;
    scrubber.loc = round(map(mouseX - width / 2, 0, ftWidth, 0, songLen) / beatLen) * beatLen;
    if (scrubber.loc < 0) scrubber.loc = 0;
    else if (scrubber.loc > songLen + 1) scrubber.loc = songLen;
  }
  int i = 0;
  for (Limb l : frameTracks.keySet()) {
    rectMode(LEFT);
    stroke(30);
    fill(50);
    strokeWeight(1.5);
    rect(ftX, i * trackHeight, ftX + ftWidth, (i + 1) * trackHeight);
    frameTracks.get(l).draw(i++);
    if (focusedLimb == null) frameTracks.get(l).animate(l, scrubber.loc);
  }
  scrubber.draw();
  float y = round((mouseY +  trackHeight / 2) / trackHeight) * trackHeight;
  boolean h = mouseX > width - 15 - trackHeight / 2;
  fill(h ? #FF0026 : 50);
  stroke(h ? 50 : #FF0026);
  strokeWeight(1.5);
  ellipse(width - 15, y - trackHeight / 2, trackHeight * 0.5, trackHeight * 0.5);
  line(width - 15 - 3, y - trackHeight / 2, width - 15 + 3, y - trackHeight / 2);
  line(width - 15, y - 3 - trackHeight / 2, width - 15, y - trackHeight / 2 + 3);
}