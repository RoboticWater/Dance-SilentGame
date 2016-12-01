public void timer() {
  globalTime = MAX_TIME - (millis() - turnStart);
  //println(time);
  fill(side ? #EF3C29 : #3E4DCB);
  text(str(globalTime / 60000) + ":" + nf((globalTime / 1000) % 60, 2), 20, 60);
  //stroke(activeScreen.bgcol);
  //strokeWeight(2);
  //float loc = map(time, 0, MAX_TIME, 0, 100);
  //pushMatrix();
  //translate(20, 20, 0);
  //line(0, 0, loc, 0);
  //ellipse(loc, 0, 3, 3);
  //popMatrix();
}