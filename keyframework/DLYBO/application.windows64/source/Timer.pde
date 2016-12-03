public void timer() {
  globalTime = MAX_TIME - (millis() - turnStart);
  fill(side ? #EF3C29 : #3E4DCB);
  text(str(globalTime / 60000) + ":" + nf((globalTime / 1000) % 60, 2), 20, 60);
}