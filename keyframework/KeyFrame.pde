public class KeyFrame {
  int      time;
  float  rotate;
  KeyFrame next;
  KeyFrame prev;
  color     col;
  public KeyFrame(int _time, float _rotate) {
    time = _time;
    rotate = _rotate;
  }
  public KeyFrame(int _time, float _rotate, KeyFrame _prev) {
    time = _time;
    rotate = _rotate;
    prev = _prev;
  }
  public void draw(int track) {
    boolean h = (hover(track) || focusedFrames.contains(this)) && prev != null;
    if (h && mousePressed && !scrubFocus) {
      if (!focusedFrames.contains(this)) focusedFrames.add(this);
      time = scrubber.loc;
    } else if (h) {
      focusedFrames.remove(this);
    }
    if (prev != null) {
      pushMatrix();
      rectMode(CENTER);
      translate(map(time, 0, exerptLen, width / 2, width), (track + 0.5) * trackHeight);
      rotate(PI / 4);
      noFill();
      strokeWeight(1.5);
      stroke(h ? #FC5468 : #00aaff);
      rect(0, 0, trackHeight * 0.3, trackHeight * 0.3);
      popMatrix();
    }
    if (next != null) next.draw(track);
  }
  public boolean hover(int track) {
    return dist(mouseX, mouseY, map(time, 0, exerptLen, width / 2, width), (track + 0.5) * trackHeight) < trackHeight * 0.4;
  }
  public void animate(Limb limb, int sTime) {
    float b = endRotation() + rotate;     //Initial angle
    if (sTime < time) {
      limb.move();
      float t = time - sTime;    //Current time
      float d = time - (prev == null ? 0 : prev.time);//Duration of animation
      float c = -rotate;          //Total change in angle
      //limb.angle = t * c / d + b;
      t /= d/2;
      if (t < 1) {
        limb.angle = c/2*t*t + b;
        return;
      }
      t--;
      limb.angle = -c/2 * (t*(t-2) - 1) + b;
    } else if (sTime == time) {
      limb.move();
      limb.angle = b;
    } else {
      if (next != null) next.animate(limb, sTime);
      else {
        limb.move();
        limb.angle = b;
      }
    }
    //if (next == null) {
    //  limb.angle = b;
    //} else if(sTime > next.time) {
    //  next.animate(limb, sTime);
    //} else {
    //  float t = sTime - time;    //Current time
    //  float d = next.time - time;//Duration of animation
    //  float c = next.rotate;          //Total change in angle
    //  limb.angle =  t * c / d;
    //t /= d/2;
    //if (t < 1) {
    //  limb.angle = c/2*t*t + b;
    //  return;
    //}
    //t--;
    //limb.angle = -c/2 * (t*(t-2) - 1) + b;
    //}
  }
  public float endRotation() {
    if (prev == null) return 0;
    return prev.endRotation() + prev.rotate;
  }
  public void remove(int t) {
    if (hover(t)) {
      if (prev == null) return;
      prev.next = next;
      if (next != null) next.rotate += rotate;
      prev.animate(dancer.limbs.get(t), scrubber.loc);
    } else if (next != null) {
      next.remove(t);
    }
  }
  public void add(int _time, float _rotate) {
    if (_time > time) {
      if (next == null) {
        next = new KeyFrame(_time, _rotate, this);
      } else {
        next.add(_time, _rotate);
      }
    } else if (_time == time) {
      rotate += _rotate;
    } else {
      if (next == null) {
        next = new KeyFrame(time, rotate, this);
      } else {
        KeyFrame hold = next;
        next = new KeyFrame(time, rotate, this);
        hold.prev = next;
        next.next = hold;
      }
      time = _time;
      rotate = _rotate;
    }
  }
  public String toString() {
    return "(" + str(rotate) + ", " + str(time) + ") " + (next == null ? "" : next.toString());
  }
}