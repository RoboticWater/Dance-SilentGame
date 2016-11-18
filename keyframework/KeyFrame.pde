public class KeyFrame {
  int      time;
  float  rotate;
  KeyFrame next;
  KeyFrame prev;
  Limb     limb;
  public KeyFrame(int _time, float _rotate) {
    time = _time;
    dRot = _rotate;
  }
  public void draw(int track) {
    pushMatrix();
    rotate(PI / 4);
    rect(0, 0, tHeight * 0.7, tHeight * 0.7, CENTER);
    popMatrix();
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
      l.angle = -c/2 * (t*(t-2) - 1) + b;
    }
  }
  public float endRotation() {
    if (prev == null) return rotate;
    return prev.endRotation() + rotate;
  }
  public void add(int _time, float _rotate) {
    if (_time > time) {
      if (next == null) {
        next = new KeyFrame(_time, _rotate);
        next.prev = this;
      } else {
        next.add(_time, _rotate);
      }
    } else if (_time == time) {
      rotate = _rotate;
    } else {
      if (next == null) {
        next = new KeyFrame(time, rotate);
        next.prev = this;
      } else {
        KeyFrame hold = next;
        next = new KeyFrame(time, rotate);
        next.next = hold;
      }
      time = _time;
      rotate = _rotate;
    }
  }
}