import traer.physics.*;

ParticleSystem physics;
float SPRING_STRENGTH = 0.2;
float SPRING_DAMPING = 0.1;
float tension = 0.85;
public class JiggleLimb {
  Limb parent;
  Particle tOrg, tExt;
  Particle bOrg, bExt;
  Particle[][] particles;
  Particle[][] fixedParticles;
  JiggleLimb next, prev;
  float angle;
  float oSize;
  float eSize;
  PVector org, ext;
  public JiggleLimb(Limb _parent, JiggleLimb _jParent, float _oSize, float _eSize, int _num) {
    org = new PVector();
    ext = new PVector();
    parent = _parent;
    prev = _jParent;
    if (prev != null) prev.next = this;
    parent.jLimb = this;
    oSize = _oSize;
    eSize = _eSize;
    angle = parent.realAngle();
    particles = new Particle[_num][2];
    fixedParticles = new Particle[_num][2];
    mesh(_num);
  }
  public void draw() {
    boolean root = prev == null;
    boolean tail = next == null;

    fill(0);
    stroke(0);
    beginShape();
    curveVertex(particles[0][0].position().x(), particles[0][0].position().y());
    for (int i = 0; i < particles.length - 1; i++) {
      curveVertex(particles[i][0].position().x(), particles[i][0].position().y());
    }
    curveVertex(particles[particles.length - 1][0].position().x(), particles[particles.length - 1][0].position().y());
    curveVertex(particles[particles.length - 1][0].position().x(), particles[particles.length - 1][0].position().y());
    vertex(particles[particles.length - 1][1].position().x(), particles[particles.length - 1][1].position().y());
    for (int i = particles.length - 1; i >= 0; i--) {
      curveVertex(particles[i][1].position().x(), particles[i][1].position().y());
    }
    curveVertex(particles[0][1].position().x(), particles[0][1].position().y());
    endShape();
    if (root) arc(org.x, org.y, oSize, oSize, angle + HALF_PI, angle + HALF_PI + PI);
    //if (tail) arc(ext.x, ext.y, eSize, eSize, angle + HALF_PI + PI, angle + HALF_PI + TWO_PI);
    //pushMatrix();
    //colorMode(HSB);
    //stroke(color(test*20, 255, 255));
    //strokeWeight(3);
    //colorMode(RGB);
    //translate(0,0,1);
    //for (int x = 0; x < particles.length; x++) {
    //  for (int y = 0; y < particles[0].length; y++) {
    //    point(particles[x][y].position().x(), particles[x][y].position().y());
    //  }
    //}
    //test++;
    //popMatrix();

  }
  public void update(float ox, float oy, float ex, float ey, float a) {
    boolean root = prev == null;
    boolean tail = next == null;
    angle = a;
    org.set(ox, oy);
    ext.set(ex, ey);
    PVector[] tops = offVects(a, ox, oy, ex, ey, 0);
    PVector[] bots = offVects(a, ox, oy, ex, ey, PI);
    if (root) {
      fixedParticles[0][0].position().set(tops[0].x, tops[0].y, 0);
      fixedParticles[0][1].position().set(bots[0].x, bots[0].y, 0);
    }
    for (int x = 1; x < particles.length; x++) {
      int n = tail ? particles.length - 1 : particles.length;
      float tvx = map(x, 0, n, tops[0].x, tops[1].x);
      float tvy = map(x, 0, n, tops[0].y, tops[1].y);
      float bvx = map(x, 0, n, bots[0].x, bots[1].x);
      float bvy = map(x, 0, n, bots[0].y, bots[1].y);
      fixedParticles[x][0].position().set(tvx, tvy, 0);
      fixedParticles[x][1].position().set(bvx, bvy, 0);
    }
  }
  private void mesh(int _num) {
    boolean root = prev == null;
    PVector[] p = parent.realPosition();
    PVector[] tops = offVects(angle, p[0].x, p[0].y, p[1].x, p[1].y, 0);
    PVector[] bots = offVects(angle, p[0].x, p[0].y, p[1].x, p[1].y, PI);
    org.set(p[0].x, p[0].y);
    ext.set(p[1].x, p[1].y);
    if (root) {
      particles[0][0] = physics.makeParticle(0.2, tops[0].x, tops[0].y, 0);
      particles[0][1] = physics.makeParticle(0.2, bots[0].x, bots[0].y, 0);
      fixedParticles[0][0] = physics.makeParticle(0.2, tops[0].x, tops[0].y, 0);
      fixedParticles[0][1] = physics.makeParticle(0.2, bots[0].x, bots[0].y, 0);
      fixedParticles[0][0].makeFixed();
      fixedParticles[0][1].makeFixed();
      physics.makeSpring(particles[0][0], fixedParticles[0][0], SPRING_STRENGTH * 0.6, SPRING_DAMPING, 0);
      physics.makeSpring(particles[0][1], fixedParticles[0][1], SPRING_STRENGTH * 0.6, SPRING_DAMPING, 0);
    } else {
      particles[0][0] = prev.particles[prev.particles.length - 1][0];
      particles[0][1] = prev.particles[prev.particles.length - 1][1];
      fixedParticles[0][0] = prev.fixedParticles[prev.fixedParticles.length - 1][0];
      fixedParticles[0][1] = prev.fixedParticles[prev.fixedParticles.length - 1][1];
    }
    for (int x = 1; x < _num; x++) {
      int n = particles.length - 10;
      float tvx = map(x, 0, n, tops[0].x, tops[1].x);
      float tvy = map(x, 0, n, tops[0].y, tops[1].y);
      float bvx = map(x, 0, n, bots[0].x, bots[1].x);
      float bvy = map(x, 0, n, bots[0].y, bots[1].y);
      particles[x][0] = physics.makeParticle(0.2, tvx, tvy, 0);
      particles[x][1] = physics.makeParticle(0.2, bvx, bvy, 0);

      fixedParticles[x][0] = physics.makeParticle(0.2, tvx, tvy, 0);
      fixedParticles[x][1] = physics.makeParticle(0.2, bvx, bvy, 0);
      fixedParticles[x][0].makeFixed();
      fixedParticles[x][1].makeFixed();

      physics.makeSpring(particles[x][0], fixedParticles[x][0], SPRING_STRENGTH * 0.6, SPRING_DAMPING, 0);
      physics.makeSpring(particles[x][1], fixedParticles[x][1], SPRING_STRENGTH * 0.6, SPRING_DAMPING, 0);
      float d;
      d = particles[x - 1][0].position().distanceTo(particles[x][0].position());
      physics.makeSpring(particles[x - 1][0], particles[x][0], SPRING_STRENGTH * 0.02, SPRING_DAMPING, d * tension);
      d = particles[x - 1][1].position().distanceTo(particles[x][1].position());
      physics.makeSpring(particles[x - 1][1], particles[x][1], SPRING_STRENGTH * 0.02, SPRING_DAMPING, d * tension);
    }
  }
  private PVector[] offVects(float a, float ox, float oy, float ex, float ey, float off) {
    PVector start = new PVector(oSize / 2, 0);
    start.rotate(a + HALF_PI + off);
    start.add(new PVector(ox, oy));
    PVector end = new PVector(eSize / 2, 0);
    end.rotate(a + HALF_PI + off);
    end.add(new PVector(ex, ey));
    PVector[] out = {start, end};
    return out;
  }
}