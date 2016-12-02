public void frameTrack() {
  
  if (!inMenu && mousePressed && ((mouseX >= width / 2 && mouseX <= width - trackHeight * 0.5 - 15) || scrubFocus) && focusedLimb == null) {
    if (!frameHover() && focusedFrames.size() == 0) scrubFocus = true;
    doAnim = false;
    scrubber.loc = round(map(mouseX - width / 2, 0, ftWidth, 0, exerptLen) / beatLen) * beatLen;
    if (scrubber.loc < 0) scrubber.loc = 0;
    else if (scrubber.loc > exerptLen + 1) scrubber.loc = exerptLen;
  }
  for (Limb l : dancer.limbs) {
    rectMode(LEFT);
    stroke(30);
    fill(50);
    strokeWeight(1.5);
    int i = frameTracks.get(l).track;
    rect(ftX, i * trackHeight, ftX + ftWidth, (i + 1) * trackHeight);
    fill(70);
    textSize(trackHeight * 0.8);
    text(l.name, ftX + 10, (i + 1) * trackHeight - 7);
    textSize(48);
    frameTracks.get(l).draw();
    if (focusedLimb == null) frameTracks.get(l).animate(l, scrubber.loc);
  }
  scrubber.draw();
  float y = round((mouseY +  trackHeight / 2) / trackHeight) * trackHeight;
  boolean h = mouseX > width - 15 - trackHeight / 2;
  fill(h ? dancer.limbs.get(round((mouseY +  trackHeight / 2) / trackHeight) - 1).col : 50);
  stroke(h ? 50 : dancer.limbs.get(round((mouseY +  trackHeight / 2) / trackHeight) - 1).col);
  strokeWeight(1.5);
  ellipse(width - 15, y - trackHeight / 2, trackHeight * 0.5, trackHeight * 0.5);
  line(width - 15 - 3, y - trackHeight / 2, width - 15 + 3, y - trackHeight / 2);
  line(width - 15, y - 3 - trackHeight / 2, width - 15, y - trackHeight / 2 + 3);
}
public boolean frameHover() {
  for (Limb l : dancer.limbs) {
    if (frameTracks.get(l).trackHover()) return true;
  }
  return false;
}