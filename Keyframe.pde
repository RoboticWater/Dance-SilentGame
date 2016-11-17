class Keyframe {
  float sAnim;
  float eAnim;
  float vAnim;
  float dAnim;
  float sTime;
  float eTime;
  //Function;
  //KeyframeType;
  Keyframe(float sAnim, float dAnim, float sTime) {
    float dTime = 1000;
    this.sAnim = sAnim;
    this.sTime = sTime;
    this.eTime = sTime + dTime;
    this.eAnim = sAnim + dAnim;
    this.dAnim = dAnim;
    this.vAnim = dAnim / dTime;
    //this.Function = LINEAR;
    //this.KeyframeType = KEYFRAME;
  }
  void draw(int trackLoc) {
    int h = hover(trackLoc);
    float x0 = map(sTime, 0, totalTime * 1000, 0, width);
    float x1 = map(eTime, 0, totalTime * 1000, 0, width);
    float y0 = trackLoc * trackSize;
    float y1 = (trackLoc + 1) * trackSize;
    if (h > 0 || kFocus == this) fill(#ffff55);
    else fill(#ff5555);
    
    rect(x0, trackLoc * trackSize, x1 - x0, trackSize);
    fill(#5555ff);
    if (mousePressed && (h > 1 || kFocus == this)) {
      kFocus = this;
      float loc = int(mouseX / (width / (totalTime * step)))* (width / (totalTime * step));
      eTime = map(loc, 0, width, 0, totalTime * 1000);
      vAnim = dAnim / (eTime - sTime);
    } else {
      kFocus = null;
    }
    if (h == 2 || kFocus == this) {
      rect(x0, trackLoc * trackSize, 10, trackSize);
    }
    if (h == 3 || kFocus == this) {
      rect(x1, trackLoc * trackSize, -10, trackSize);
    }
  }
  int hover(int trackLoc) {
    float x0 = map(sTime, 0, totalTime * 1000, 0, width);
    float y0 = trackLoc * trackSize;
    float x1 = map(eTime, 0, totalTime * 1000, 0, width);
    float y1 = (trackLoc + 1) * trackSize;
    if (mouseX > x0 && mouseX < x1 && mouseY > y0 && mouseY < y1) {
      if (mouseX < x0 + 10) {
        return 2;
      } else if (mouseX > x1 - 10) {
        return 3;
      }
      return 1;
    }
    return 0;
  }
}

public enum Function {
  LINEAR, EASE, EASEIN, EASEOUT
}
public enum KeyframeType {
  KEYFRAME, SIN
}