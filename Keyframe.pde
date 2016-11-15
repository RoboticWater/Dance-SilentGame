class Keyframe {
  float sAnim;
  float eAnim;
  float sTime;
  float eTime;
  int dir;
  //Function;
  //KeyframeType;
  Keyframe(float sAnim, float eAnim, float sTime, int dir) {
    this.sAnim = sAnim;
    this.eAnim = eAnim;
    this.sTime = sTime;
    this.eTime = sTime + 1000;
    this.dir = dir;
    //this.Function = LINEAR;
    //this.KeyframeType = KEYFRAME;
  }
  void draw(int trackLoc) {
    fill(#ff5555);
    rect(map(sTime, 0, 10000, 0, width), trackLoc, map(eTime - sTime, 0, 10000, 0, width), 20);
  }
}

public enum Function {
  LINEAR, EASE, EASEIN, EASEOUT
}
public enum KeyframeType {
  KEYFRAME, SIN
}