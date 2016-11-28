import traer.physics.*;

ParticleSystem physics;
float SPRING_STRENGTH = 0.2;
float SPRING_DAMPING = 0.1;
float tension = 0.85;
public class JiggleLimb {
  Limb parent;
  Particle tOrg, tExt;
  Particle org, ext;
  Particle bOrg, bExt;
  Particle[][] particles;
  Particle[][] fixedParticles;
  JiggleLimb next, prev;
  float angle;
  float oSize;
  float eSize;
  public JiggleLimb(Limb _parent, JiggleLimb _jParent, float _oSize, float _eSize, int _num) {
    parent = _parent;
    prev = _jParent;
    if (prev != null) prev.next = this;
    parent.jLimb = this;
    oSize = _oSize;
    eSize = _eSize;
    angle = parent.realAngle();
    //println(angle);
    particles = new Particle[_num][3];
    fixedParticles = new Particle[_num][2];
    if (prev == null) meshNoPrev(_num);
    else meshPrev(_num);
  }
  public void draw() {
    //for (int x = 0; x < particles.length; x++) {
    //  for (int y = 0; y < particles[0].length; y++) {
    //    point(particles[x][y].position().x(), particles[x][y].position().y());
    //  }
    //}
    fill(0);
    stroke(0);
    beginShape();
    curveVertex(particles[0][0].position().x(), particles[0][0].position().y());
    for (int i = 0; i < particles.length - 1; i++) {
      curveVertex(particles[i][0].position().x(), particles[i][0].position().y());
    }
    curveVertex(particles[particles.length - 1][0].position().x(), particles[particles.length - 1][0].position().y());
    curveVertex(particles[particles.length - 1][0].position().x(), particles[particles.length - 1][0].position().y());
    vertex(particles[particles.length - 1][2].position().x(), particles[particles.length - 1][2].position().y());
    for (int i = particles.length - 1; i >= 0; i--) {
      curveVertex(particles[i][2].position().x(), particles[i][2].position().y());
    }
    curveVertex(particles[0][2].position().x(), particles[0][2].position().y());
    endShape();
    //arc(org.position().x(), org.position().y(), oSize, oSize, angle + HALF_PI, angle + HALF_PI + PI);
    //arc(ext.position().x(), ext.position().y(), eSize, eSize, angle + HALF_PI + PI, angle + HALF_PI + TWO_PI);
  }
  public void update(float ox, float oy, float ex, float ey, float a) {
    boolean root = prev == null;
    boolean tip  = next == null;
    angle = a;
    PVector[] tops = offVects(a, ox, oy, ex, ey, 0);
    PVector[] bots = offVects(a, ox, oy, ex, ey, PI);
    org.position().set(ox, oy, 0);
    org.velocity().clear();
    ext.position().set(ex, ey, 0);
    ext.velocity().clear();
    if (root) {
      tOrg.position().set(tops[0].x, tops[0].y, 0);
      tOrg.velocity().clear();
      bOrg.position().set(bots[0].x, bots[0].y, 0);
      bOrg.velocity().clear();
    }
    if (tip) {
      tExt.position().set(tops[1].x, tops[1].y, 0);
      tExt.velocity().clear();
      bExt.position().set(bots[1].x, bots[1].y, 0);
      bExt.velocity().clear();
    }
    for (int x = 0; x < particles.length; x++) {
      float tvx = map(x, 0, particles.length - 1, tops[0].x, tops[1].x);
      float tvy = map(x, 0, particles.length - 1, tops[0].y, tops[1].y);
      float bvx = map(x, 0, particles.length - 1, bots[0].x, bots[1].x);
      float bvy = map(x, 0, particles.length - 1, bots[0].y, bots[1].y);
      fixedParticles[x][0].position().set(tvx, tvy, 0);
      fixedParticles[x][1].position().set(bvx, bvy, 0);
    }
  }
  private void meshNoPrev(int _num) {
    PVector[] p = parent.realPosition();
    PVector[] tops = offVects(angle, p[0].x, p[0].y, p[1].x, p[1].y, 0);
    PVector[] bots = offVects(angle, p[0].x, p[0].y, p[1].x, p[1].y, PI);
    for (int x = 0; x < _num; x++) {
      float vx = map(x, 0, _num - 1, p[0].x, p[1].x);
      float vy = map(x, 0, _num - 1, p[0].y, p[1].y);
      float tvx = map(x, 0, _num - 1, tops[0].x, tops[1].x);
      float tvy = map(x, 0, _num - 1, tops[0].y, tops[1].y);
      float bvx = map(x, 0, _num - 1, bots[0].x, bots[1].x);
      float bvy = map(x, 0, _num - 1, bots[0].y, bots[1].y);
      particles[x][0] = physics.makeParticle(0.2, tvx, tvy, 0);
      particles[x][1] = physics.makeParticle(0.2, vx, vy, 0);
      particles[x][2] = physics.makeParticle(0.2, bvx, bvy, 0);
      
      fixedParticles[x][0] = physics.makeParticle(0.2, tvx, tvy, 0);
      fixedParticles[x][0].makeFixed();
      fixedParticles[x][1] = physics.makeParticle(0.2, bvx, bvy, 0);
      fixedParticles[x][1].makeFixed();
      physics.makeSpring(particles[x][0], fixedParticles[x][0], SPRING_STRENGTH, SPRING_DAMPING, 0);
      physics.makeSpring(particles[x][2], fixedParticles[x][1], SPRING_STRENGTH, SPRING_DAMPING, 0);
      if (x == 0 || x == _num - 1) {
        particles[x][0].makeFixed();
        particles[x][1].makeFixed();
        particles[x][2].makeFixed();
      }
      if (x > 0) {
        float d = particles[x - 1][0].position().distanceTo(particles[x][0].position());
        physics.makeSpring(particles[x - 1][0], particles[x][0], SPRING_STRENGTH, SPRING_DAMPING, d * tension);
        d = particles[x - 1][1].position().distanceTo(particles[x][1].position());
        physics.makeSpring(particles[x - 1][1], particles[x][1], SPRING_STRENGTH, SPRING_DAMPING, d * tension);
        d = particles[x - 1][2].position().distanceTo(particles[x][2].position());
        physics.makeSpring(particles[x - 1][2], particles[x][2], SPRING_STRENGTH, SPRING_DAMPING, d * tension);
      }
    }
    tOrg = particles[0][0];
    tExt = particles[_num - 1][0];
    org = particles[0][1];
    ext = particles[_num - 1][1];
    bOrg = particles[0][2];
    bExt = particles[_num - 1][2];
  }
  private void meshPrev(int _num) {
    PVector[] p = parent.realPosition();
    PVector[] tops = offVects(angle, p[0].x, p[0].y, p[1].x, p[1].y, 0);
    PVector[] bots = offVects(angle, p[0].x, p[0].y, p[1].x, p[1].y, PI);
    particles[0][0] = prev.particles[prev.particles.length - 1][0];
    particles[0][1] = prev.particles[prev.particles.length - 1][1];
    particles[0][2] = prev.particles[prev.particles.length - 1][2];
    fixedParticles[0][0] = prev.fixedParticles[prev.fixedParticles.length - 1][0];
    fixedParticles[0][1] = prev.fixedParticles[prev.fixedParticles.length - 1][1];
    for (int x = 1; x < _num; x++) {
      float vx = map(x, 0, _num - 1, p[0].x, p[1].x);
      float vy = map(x, 0, _num - 1, p[0].y, p[1].y);
      float tvx = map(x, 0, _num - 1, tops[0].x, tops[1].x);
      float tvy = map(x, 0, _num - 1, tops[0].y, tops[1].y);
      float bvx = map(x, 0, _num - 1, bots[0].x, bots[1].x);
      float bvy = map(x, 0, _num - 1, bots[0].y, bots[1].y);
      particles[x][0] = physics.makeParticle(0.2, tvx, tvy, 0);
      particles[x][1] = physics.makeParticle(0.2, vx, vy, 0);
      particles[x][2] = physics.makeParticle(0.2, bvx, bvy, 0);
      
      fixedParticles[x][0] = physics.makeParticle(0.2, tvx, tvy, 0);
      fixedParticles[x][0].makeFixed();
      fixedParticles[x][1] = physics.makeParticle(0.2, bvx, bvy, 0);
      fixedParticles[x][1].makeFixed();
      physics.makeSpring(particles[x][0], fixedParticles[x][0], SPRING_STRENGTH / 4, SPRING_DAMPING, 0);
      physics.makeSpring(particles[x][2], fixedParticles[x][1], SPRING_STRENGTH / 4, SPRING_DAMPING, 0);
      if (x == _num - 1) {
        particles[x][0].makeFixed();
        particles[x][1].makeFixed();
        particles[x][2].makeFixed();
      }
      if (x > 0) {
        float d = particles[x - 1][0].position().distanceTo(particles[x][0].position());
        physics.makeSpring(particles[x - 1][0], particles[x][0], SPRING_STRENGTH, SPRING_DAMPING, d * tension);
        d = particles[x - 1][1].position().distanceTo(particles[x][1].position());
        physics.makeSpring(particles[x - 1][1], particles[x][1], SPRING_STRENGTH, SPRING_DAMPING, d * tension);
        d = particles[x - 1][2].position().distanceTo(particles[x][2].position());
        physics.makeSpring(particles[x - 1][2], particles[x][2], SPRING_STRENGTH, SPRING_DAMPING, d * tension);
      }
    }
    //tOrg = particles[0][0];
    //tExt = particles[_num - 1][0];
    //org = particles[0][1];
    //ext = particles[_num - 1][1];
    //bOrg = particles[0][2];
    //bExt = particles[_num - 1][2];
    
    tOrg = particles[0][0];
    tOrg.makeFree();
    tExt = particles[_num - 1][0];
    org = particles[0][1];
    org.makeFixed();
    ext = particles[_num - 1][1];
    bOrg = particles[0][2];
    bOrg.makeFree();
    bExt = particles[_num - 1][2];
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