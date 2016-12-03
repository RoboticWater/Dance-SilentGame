public class KeyFrame {
  int      time;
  int     track;
  float  rotate;
  float    size;
  KeyFrame next;
  KeyFrame prev;
  color     col;
  boolean first;
  public KeyFrame(int _time, float _rotate, int _track, color _col) {
    time = _time;
    rotate = _rotate;
    track = _track;
    col = _col;
    first = true;
  }
  public KeyFrame(int _time, float _rotate, KeyFrame _prev, int _track, color _col, boolean _first) {
    time = _time;
    rotate = _rotate;
    prev = _prev;
    track = _track;
    col = _col;
    first = _first;
  }
  public KeyFrame(int _time, float _rotate, KeyFrame _prev, int _track, color _col) {
    time = _time;
    rotate = _rotate;
    prev = _prev;
    track = _track;
    col = _col;
    first = false;
  }
  public void draw() {
    if (!first && time > exerptOff) {
      boolean h = (hover() || focusedFrames.contains(this)) && prev != null;
      if (!inMenu && h && mousePressed && !scrubFocus) {
        if (!focusedFrames.contains(this)) focusedFrames.add(this);
        time = scrubber.loc;
      } else if (h) {
        if (time > (next == null ? time : next.time)) swap(next);
        else if (time < (prev == null ? 0 : prev.time)) swap(prev);
        focusedFrames.remove(this);
      }
      pushMatrix();
      rectMode(CENTER);
      translate(map(time, exerptOff, exerptOff + exerptLen, width / 2, width), (track + 0.5) * trackHeight);
      rotate(PI / 4);
      noFill();
      strokeWeight(1.5);
      stroke(h ? 255 : col);
      size = lerp(size, trackHeight * 0.3, 0.17);
      rect(0, 0, size, size);
      popMatrix();
    }
    if (next != null) next.draw();
  }
  public boolean hover() {
    return prev != null && dist(mouseX, mouseY, 
                                map(time, exerptOff, exerptOff + exerptLen, width / 2, width),
                                (track + 0.5) * trackHeight) < trackHeight * 0.4;
  }
  public boolean trackHover() {
    return hover() ? true : (next == null ? false : next.trackHover());
  }
  public void overwrite(KeyFrame k) {
    if (k == next) {
      next = k.next;
      if (next != null) next.prev = this;
    } else {
      prev = k.prev;
      if (prev != null) prev.next = this;
    }
  }
  public void swap(KeyFrame k) {
    if (k == next) {
      next = next.next;
      next.prev = prev;
      next.next = this;
      prev = k;
    } else {
      prev = prev.prev;
      prev.next = next;
      prev.prev = this;
      next = k;
    }
  }
  public void animate(Limb limb, int sTime) {
    float b = endRotation() + rotate;
    if (sTime < time) {
      limb.move();
      float t = time - sTime;
      float d = time - (prev == null ? 0 : prev.time);
      float c = -rotate;
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
  }
  public float endRotation() {
    if (prev == null) return 0;
    return prev.endRotation() + prev.rotate;
  }
  public void remove(int t) {
    if (hover()) {
      if (prev == null) return;
      prev.next = next;
      if (next != null) next.rotate += rotate;
      prev.animate(dancer.limbs.get(t), scrubber.loc);
    } else if (next != null) {
      next.remove(t);
    }
  }
  public void add(KeyFrame k) {
    if (next == null) {
      next = k;
      k.prev = this;
    }
    else next.add(k);
  }
  public void add(int _time, float _rotate) {
    if (_time > time) {
      if (next == null) {
        next = new KeyFrame(_time, _rotate, this, track, col);
      } else {
        next.add(_time, _rotate);
      }
    } else if (_time == time) {
      rotate += _rotate;
    } else {
      if (next == null) {
        next = new KeyFrame(time, rotate, this, track, col);
      } else {
        KeyFrame hold = next;
        next = new KeyFrame(time, rotate, this, track, col);
        hold.prev = next;
        next.next = hold;
      }
      time = _time;
      rotate = _rotate;
      size = 0;
      next.size = trackHeight * 0.3;
    }
  }
  public KeyFrame getEnd() {
    //print("[" + nfs(time / 1000, 2, 2) + ", " + nfs(rotate, 1, 2) + "]-");
    return next == null ? this : next.getEnd();
  }
  public String toString() {
    return "(" + str(rotate) + ", " + str(time) + ") " + (next == null ? "" : next.toString());
  }
}