class Armature {
  PVector org, ext;
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
    this.ext = PVector.fromAngle(rot);
    this.ext.setMag(mag);
    this.mag = mag;
    this.angle = 0;
  }
  Armature(PVector org, PVector ext) {
    this.org = org.get();
    this.ext = ext.get();
    this.mag = ext.mag();
    this.angle = 0;
  }
  Armature(Armature parent, float mag, float rot) {
    this.ext = PVector.fromAngle(rot);
    this.ext.setMag(mag);
    this.org = new PVector();
    this.mag = mag;
    this.parent = parent;
    this.parent.child = this;
    this.org.set(PVector.add(parent.org, parent.ext));
    this.angle = 0;
    //addParent(parent);
  }
  void draw() {
    noFill();
    stroke(0);
    line(org.x, org.y, org.x + ext.x, org.y + ext.y);
    if (hovered() || this == focus) {
      stroke(#ff1111);
      ellipse(org.x + ext.x, org.y + ext.y, 20, 20);
      stroke(#1111ff);
      ellipse(org.x, org.y, mag * 2, mag * 2);
      if (mousePressed) {
        if (focus == null) start = ext.heading();
        focus = this;
        PVector n = new PVector(mouseX - org.x, mouseY - org.y);
        float a = n.heading();
        float b = ext.heading();
        n.setMag(mag);
        println(dRot);
        if ((a<0)^(b<0) && abs(a) > HALF_PI) {
          if(a > b) b += TWO_PI;
          else a += TWO_PI;
        }
        //CHANGE ROTATIONS TO WORK ADDATIVELY NOT STATICALLY
        dRot += (a - b);
        if (child != null) {
          //child.update(PVector.add(n, org), a - b);
        }
        ext.set(n);
      }
      else {
        focus = null;
      }
    }
    if (child != null) child.draw();
  }
  boolean hovered() {
    return dist(mouseX, mouseY, org.x + ext.x, org.y + ext.y) < 20 && focus == null;
  }
  void addParent(Armature p) {
    parent = p;
    p.child = this;
    this.org.set(PVector.add(p.org, p.ext));
  }
  void addChild(Armature c) {
    child = c;
    c.parent = this;
    c.org.set(PVector.add(org, ext));
  }
  void update(PVector p, float rot) {
    //println(rot);
    ext.rotate(rot);
    org.set(p);
    if (child !=null) child.update(PVector.add(ext, org), rot);
  }
  void animate(PVector p, float rot, int dir) {
    //println(rot);
    float r = rot - ext.heading();//dir < 0 ?  : ext.heading() - rot;
    ext.rotate(r);
    org.set(p);
    if (child !=null) child.animate(PVector.add(ext, org), rot, dir);
  }
}