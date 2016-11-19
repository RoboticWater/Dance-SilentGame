public class KeyFrame {
  int      time;
  float  rotate;
  KeyFrame next;
  KeyFrame prev;
  Limb     limb;
  public KeyFrame(int _time, float _rotate, Limb _limb) {
    time = _time;
    rotate = _rotate;
    limb = _limb;
  }
  public void draw(int track) {
    frameTrack.pushMatrix();
    frameTrack.rectMode(CENTER);
    frameTrack.translate(map(time, 0, songLen, 0, width), (track + 0.5) * frameTrack.tHeight);
    frameTrack.rotate(PI / 4);
    frameTrack.noStroke();
    frameTrack.fill(#00aaff);
    frameTrack.rect(0, 0, frameTrack.tHeight * 0.5, frameTrack.tHeight * 0.5);
    frameTrack.popMatrix();
    if (next != null) next.draw(track);
  }
  public void animate(int sTime) {
    float b = endRotation();     //Initial angle
    if (next == null) {
      limb.angle = b;
    } else if(sTime > next.time) {
      next.animate(sTime);
    } else {
      float t = sTime - time;    //Current time
      float d = next.time - time;//Duration of animation
      float c = rotate;          //Total change in angle
      t /= d/2;
      if (t < 1) {
        limb.angle = c/2*t*t + b;
        return;
      }
      t--;
      limb.angle = -c/2 * (t*(t-2) - 1) + b;
    }
  }
  public float endRotation() {
    if (prev == null) return rotate;
    return prev.endRotation() + rotate;
  }
  public void add(int _time, float _rotate) {
    if (_time > time) {
      if (next == null) {
        next = new KeyFrame(_time, _rotate, limb);
        next.prev = this;
      } else {
        next.add(_time, _rotate);
      }
    } else if (_time == time) {
      rotate = _rotate;
    } else {
      if (next == null) {
        next = new KeyFrame(time, rotate, limb);
        next.prev = this;
      } else {
        KeyFrame hold = next;
        next = new KeyFrame(time, rotate, limb);
        next.next = hold;
      }
      time = _time;
      rotate = _rotate;
    }
  }
}