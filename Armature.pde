class Armature {
  PVector org;
  float mag;
  float angle;
  Armature parent, child;
  //Armature(float px, float py, float ex, float ey) {
  //  this.org = new PVector(px, py);
  //  this.ext = new PVector(ex, ey);
  //  this.mag = PVector.sub(org, ext).mag();
  //}
  Armature(float px, float py, float mag, float rot) {
    this.org = new PVector(px, py);
    this.mag = mag;
    this.angle = rot;
  }
  Armature(Armature parent, float mag, float rot) {
    this.org = new PVector();
    this.mag = mag;
    this.parent = parent;
    this.parent.child = this;
    this.angle = rot;
  }
  void draw() {
    noFill();
    stroke(0);
    if (parent == null) translate(org.x, org.y);
    else translate(parent.mag, 0);
    rotate(angle);
    line(0, 0, mag, 0);
    if (hovered() || this == focus) {
      stroke(#ff1111);
      ellipse(mag, 0, 20, 20);
      stroke(#1111ff);
      ellipse(0, 0, mag * 2, mag * 2);
      if (mousePressed) {
        PVector n = new PVector(mouseX - screenX(0, 0, 0), mouseY - screenY(0, 0, 0));
        PVector c = new PVector(screenX(mag, 0, 0) - screenX(0, 0, 0), screenY(mag, 0, 0) - screenY(0, 0, 0));
        //println(PVector.angleBetween(n, c));
        if (focus == null) {
          revs = 0;
          start = angle;
          focus = this;
        }
        else {
          if (sign(n.heading()) != sign(pN) && sign(n.heading() - c.heading()) != sign(pdN) && abs(n.heading()) > 0.01) {
            dRot += -TWO_PI * sign(n.heading() - c.heading());
            println(dRot);
            //println(pN);
            //println(pdN);
            //println(n.heading());
            //println((n.heading() - c.heading()));
            ////println(ppN);
            //println();
          }
          //if (sign(n.heading()) != sign(pN) && sign(n.heading() - c.heading()) == sign(pdN))
          //  revs += sign(n.heading() - c.heading());
        }
        angle += n.heading() - c.heading();
        //ppN = pN;
        pN = n.heading();
        pdN = n.heading() - c.heading();
        dRot += pdN;
      }
      else {
        focus = null;
      }
    }
    if (child != null) child.draw();
  }
  boolean hovered() {
    return dist(mouseX, mouseY, screenX(mag, 0, 0), screenY(mag, 0, 0)) < 20 && focus == null;
  }
  void animate(float b) {
    angle = b;
  }
}

int sign(float a) {
  if ((int)Math.signum(a) > -1) return 1;
  else return -1;
}