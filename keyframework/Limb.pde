public class Limb {
  float mag;
  float angle;
  float startAngle;
  color col;
  PVector origin;
  Limb parent;
  Limb child;
  public Limb(float _x, float _y, float _mag, float _angle, color _col) {
    mag    = _mag;
    angle  = _angle;
    startAngle = _angle;
    col    = _col;
    origin = new PVector(_x, _y);
  }
  public Limb(float _mag, float _angle, color _col, Limb _parent) {
    this(0, 0, _mag, _angle, _col);
    parent = _parent;
    _parent.child = this;
  }
  public void draw() {
    pushMatrix();
    if (parent == null) translate(origin.x, origin.y);
    else translate(parent.mag, 0);
    rotate(angle);
    boolean h = hovered() || this.focus;
    if (h) {
      
    }
    noFill();
    stroke(h ? lerpColor(col, #ffffff, 0.7) : col);
    strokeWeight(2);
    line(0, 0, mag, 0);
    if (child != null) child.draw();
    popMatrix();
  }
  private void rotate() {
    
  }
  private boolean hovered() {
    return dist(mouseX, mouseY, screenX(mag, 0, 0), screenY(mag, 0, 0)) < 10;
  }
}

int sign(float a) {
  if ((int)Math.signum(a) > -1) return 1;
  else return -1;
}