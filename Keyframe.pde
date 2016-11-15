class Keyframe {
  float sAnim;
  float eAnim;
  float vAnim;
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
    this.vAnim = dAnim / dTime;
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