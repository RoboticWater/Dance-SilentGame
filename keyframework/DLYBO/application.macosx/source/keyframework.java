import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.effects.*; 
import traer.physics.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.spi.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class keyframework extends PApplet {




//Screen
PFont font;
int state;
boolean inMenu = true;
boolean curs = false;
Screen activeScreen;
boolean impulse = false;
//Accessories
int blink = 0;
float eyeSize = 7;
PImage stache;
boolean doStache = false;
boolean lsd = false;
//int floorFired = 0;
//ArrayList<Tile> tiles = new ArrayList();
//ArrayList<Tile> trash = new ArrayList();
//Current Frame Data
float dRot;
float pN;
float pdN;
float sAngle;
//Animating Data
int     animStartTime;
boolean doAnim;
//Focus Pointers
Limb                focusedLimb;
ArrayList<KeyFrame> focusedFrames;
//Objects
Armature dancer;
Scrubber scrubber;
ArrayList<JiggleLimb> jLimbs;
//FrameTrack
HashMap<Limb, KeyFrame> frameTracks;
float ftWidth, ftX;
float trackHeight;
boolean down;
boolean scrubFocus = false;
//Song Data
ArrayList<Song> songs;
Song curSong;
Minim minim;
AudioPlayer player;
int beatLen = 100;
int exerptLen = 5000;
int exerptOff = 0;
//Turn Data
boolean skip = false;
boolean side = true;
int globalTime = 2000;
int turn = 0;
int turnStart = 0;
int MAX_TIME = 2 * 60000 + 2000;
public void setup() {
  
  String [] lines = loadStrings("songs.csv");
  songs = new ArrayList();
  for (String s : lines) {
    songs.add(new Song(s));
  }
  font = loadFont("LeagueGothic-Regular-48.vlw");
  stache = loadImage("stache.png");
  minim = new Minim(this);
  physics = new ParticleSystem(0.1f, 0.01f);
  setDefaults();
  textFont(font, 48);
  makeEvents();
  
}
public void draw() {
  if (random(0, 1) > 0.995f && blink < millis()) blink = millis() + 200;
  background(state > 1 ? 255 : 0xffEF3C29);
  if (state > 1 && state < 9) {
    timer();
    frameTrack();
    if (impulse) dancer.draw();
    for (JiggleLimb j : jLimbs) {
      j.draw();
    }
    dancer.draw();
    impulse = false;
    physics.tick();
    if (doAnim) {
      scrubber.loc = millis() - animStartTime;
      if (scrubber.loc > exerptOff + exerptLen) doAnim = false;
    } else if (player != null && player.isPlaying()) {
      player.pause();
    }
  } else if (state >= 9) {
    pushMatrix();
    translate(100, 0, 0);
    for (JiggleLimb j : jLimbs) {
      j.draw();
    }
    //frameTrack();
    for (Limb l : dancer.limbs) {
      frameTracks.get(l).animate(l, scrubber.loc);
    }
    dancer.draw();
    popMatrix();
    physics.tick();
    if (doAnim) {
      scrubber.loc = millis() - animStartTime;
      if (scrubber.loc > exerptOff + exerptLen) doAnim = false;
    } else if (player.isPlaying()) {
      player.pause();
    }
      endGame.draw(1, 0xff76CB3E);
  }
  stateMachine();
}
public void keyPressed() {
  if (inMenu) return;
  if (key == ' ' && state < 9) {
    if (doAnim) {
      doAnim = false;
    } else {
      //scrubber.loc = exerptOff;
      doAnim = true;
      animStartTime = millis() - scrubber.loc;
      player.cue(scrubber.loc);
      player.play();
    }
  } else if (key == 's') {
    doStache = !doStache;
  } else if (key == 'N') {
    skip = true;
  } else if (key == 'l') {
    lsd = !lsd;
  } else if (key == 'Q') {
    state = 0;
  }
}
public void mouseReleased() {
  scrubFocus = false;
  if (focusedLimb != null) {
    frameTracks.get(focusedLimb).add(scrubber.loc, dRot);
    dRot = 0;
    pN   = 0;
    pdN  = 0;
    focusedLimb = null;
  }
  down = false;
}
public void mousePressed() {
  if (mouseButton == RIGHT) {
    Limb l = dancer.limbs.get(round((mouseY +  trackHeight / 2) / trackHeight) - 1);
    frameTracks.get(l).remove(round((mouseY +  trackHeight / 2) / trackHeight) - 1);
  } else if (mouseX > width - 15 - trackHeight / 2) {
    Limb l = dancer.limbs.get(round((mouseY +  trackHeight / 2) / trackHeight) - 1);
    frameTracks.get(l).add(scrubber.loc, 0);
  }
}
public void setDefaults() {
  //Screen
  state = -1;
  //Current Frame Data
  dRot   = 0;
  sAngle = 0;
  //Animating Data
  animStartTime = 0;
  doAnim = false;
  //Focus Pointers
  focusedLimb  = null;
  focusedFrames = new ArrayList();
  //Objects
  jLimbs = new ArrayList();
  dancer = new Armature();
  scrubber = new Scrubber();
  //FrameTrack Variables
  frameTracks = new HashMap();
  ftWidth = width / 2;
  ftX = width / 2;
  trackHeight = 1.0f * height / (dancer.limbs.size());
  int i = 0;
  for (Limb l : dancer.limbs) {
    frameTracks.put(l, new KeyFrame(0, l.angle, i++, l.col));
  }
}
public class Armature {
  ArrayList<Limb> limbs;
  public Armature() {
    limbs = new ArrayList();
    limbs.add(new Limb(width / 4, height / 2 + 60, 60, -HALF_PI, 0xff8E57C9, "Chest Lower"));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), null, 40, 40, 5));
    
    limbs.add(new Limb(width / 4, height / 2 + 60, 10, HALF_PI, 0xff23ed12, "Tail"));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), null, 45, 40, 2));
    
    limbs.add(new Limb(70, 0, 0xff4241BC, "Chest Upper", limbs.get(0)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(0), 40, 45, 5));
    
    limbs.add(new Limb(30, 0, 0xff7EE838, "Neck", limbs.get(2)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 45, 40, 5));
    
    limbs.add(new Limb(30, 0, 0xffE83858, "Head", limbs.get(3)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 40, 40, 5));
    
    
    limbs.add(new Limb(50, HALF_PI, 0xffC7E838, "Right Shoulder", limbs.get(2)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), null, 35, 25, 5));
    
    limbs.add(new Limb(70, HALF_PI, 0xffE8C238, "Right Upper Arm", limbs.get(5)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 25, 25, 5));
    
    limbs.add(new Limb(60, 0, 0xffE83E38, "Right Fore Arm", limbs.get(6)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 25, 20, 5));
    
    limbs.add(new Limb(20, 0, 0xff387DE8, "Right Hand", limbs.get(7)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 20, 13, 4));
    
    
    limbs.add(new Limb(50, -HALF_PI, 0xffE8388D, "Left Shoulder", limbs.get(2)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), null, 35, 25, 5));
    
    limbs.add(new Limb(70, -HALF_PI, 0xffE8C238, "Left Upper Arm", limbs.get(9)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 25, 25, 5));
    
    limbs.add(new Limb(60, 0, 0xffE83E38, "Left Fore Arm", limbs.get(10)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 25, 20, 5));
    
    limbs.add(new Limb(20, 0, 0xff387DE8, "Left Hand", limbs.get(11)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 20, 13, 4));
    
    
    limbs.add(new Limb(30, HALF_PI, 0xff38AFE8, "Right Hip", limbs.get(1)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), null, 35, 25, 5));
    
    limbs.add(new Limb(70, -HALF_PI, 0xffE8388A, "Right Thigh", limbs.get(13)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 25, 25, 5));
    
    limbs.add(new Limb(75, 0, 0xffD0E838, "Right Leg", limbs.get(14)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 25, 20, 5));
    
    limbs.add(new Limb(20, PI/6, 0xffE8CE38, "Right Foot", limbs.get(15)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 20, 13, 4));
    
    
    limbs.add(new Limb(30, -HALF_PI, 0xffE1E838, "Left Hip", limbs.get(1)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), null, 35, 25, 5));
    
    limbs.add(new Limb(70, HALF_PI, 0xffE8388A, "Left Thigh", limbs.get(17)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 25, 25, 5));
    
    limbs.add(new Limb(75, 0, 0xffD0E838, "Left Leg", limbs.get(18)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 25, 20, 5));
    
    limbs.add(new Limb(20, -PI/6, 0xffE8CE38, "Left Foot", limbs.get(19)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 20, 13, 4));
  }
  public void draw() {
    limbs.get(0).draw();
    limbs.get(1).draw();
  }
}
public void frameTrack() {
  //println(!inMenu + " " + mousePressed + " " + ((mouseX >= width / 2 && mouseX <= width - trackHeight * 0.5 - 15) || scrubFocus) + " " + !limbHover());
  if (!inMenu && mousePressed && ((mouseX >= width / 2 && mouseX <= width - trackHeight * 0.5f - 15) || scrubFocus) && !limbHover()) {
    if (!frameHover() && focusedFrames.size() == 0) scrubFocus = true;
    down = true;
    doAnim = false;
    scrubber.loc = round(map(mouseX - width / 2, 0, ftWidth, exerptOff, exerptOff + exerptLen) / beatLen) * beatLen;
    //println(scrubber.loc < exerptOff);
    //println(scrubber.loc > exerptOff + exerptLen);
    if (scrubber.loc < exerptOff) scrubber.loc = exerptOff;
    else if (scrubber.loc > exerptOff + exerptLen) scrubber.loc = exerptOff + exerptLen;
  }
  for (Limb l : dancer.limbs) {
    rectMode(LEFT);
    stroke(30);
    fill(50);
    strokeWeight(1.5f);
    int i = frameTracks.get(l).track;
    rect(ftX, i * trackHeight, ftX + ftWidth, (i + 1) * trackHeight);
    fill(70);
    textSize(trackHeight * 0.8f);
    text(l.name, ftX + 10, (i + 1) * trackHeight - 7);
    textSize(48);
    frameTracks.get(l).draw();
    if (focusedLimb == null) frameTracks.get(l).animate(l, scrubber.loc);
  }
  scrubber.draw();
  float y = round((mouseY +  trackHeight / 2) / trackHeight) * trackHeight;
  boolean h = mouseX > width - 15 - trackHeight / 2;
  fill(h ? dancer.limbs.get(round((mouseY +  trackHeight / 2) / trackHeight) - 1).col : 50);
  stroke(h ? 50 : dancer.limbs.get(round((mouseY +  trackHeight / 2) / trackHeight) - 1).col);
  strokeWeight(1.5f);
  ellipse(width - 15, y - trackHeight / 2, trackHeight * 0.5f, trackHeight * 0.5f);
  line(width - 15 - 3, y - trackHeight / 2, width - 15 + 3, y - trackHeight / 2);
  line(width - 15, y - 3 - trackHeight / 2, width - 15, y - trackHeight / 2 + 3);
}
public boolean frameHover() {
  for (Limb l : dancer.limbs) {
    if (frameTracks.get(l).trackHover()) return true;
  }
  return false;
}
public boolean limbHover() {
  for(Limb l : dancer.limbs) {
    if (l.h) return true;
  }
  return false;
}


ParticleSystem physics;
float SPRING_STRENGTH = 0.2f;
float SPRING_DAMPING = 0.1f;
float tension = 0.85f;
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
  //public void drawMesh() {
  //  for (int i = particles.length - 1; i > 0; i--) {
  //    //point(particles[i][0].position().x(), particles[i][0].position().y());
  //    curveVertex(particles[i][0].position().x(), particles[i][0].position().y());
  //  }
  //  if (prev != null) prev.drawMesh();
  //  for (int i = 0; i < particles.length; i++) {
  //    //point(particles[i][1].position().x(), particles[i][1].position().y());
  //    curveVertex(particles[i][1].position().x(), particles[i][1].position().y());
  //  }
  //}
  public void draw() {
    boolean root = prev == null;
    boolean tail = next == null;
    //if (tail) {
    //  stroke(#3E4DCB);
    //  fill(#3E4DCB);
    //  strokeWeight(2);
    //  beginShape();
    //  curveVertex(particles[particles.length - 1][0].position().x(), particles[particles.length - 1][0].position().y());
    //  drawMesh();
    //  curveVertex(particles[particles.length - 1][1].position().x(), particles[particles.length - 1][1].position().y());
    //  endShape(CLOSE);
    //}
    if (!lsd) {
      fill(0xff41BC47);
      stroke(0xff41BC47);
    } else {
      colorMode(HSB);
      int c = color((frameCount * 1.1f) % 255, 255, 255);
      colorMode(RGB);
      fill(c);
      stroke(c);
    }
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
    if (parent.name.equals("Head")) {
      fill(255);
      noStroke();
      PVector left = new PVector(particles[particles.length - 1][0].position().x(), particles[particles.length - 1][0].position().y());
      PVector right = new PVector(particles[particles.length - 1][1].position().x(), particles[particles.length - 1][1].position().y());
      
      left.lerp(org, 0.47f);
      right.lerp(org, 0.47f);
      eyeSize = lerp(eyeSize, blink > millis() ? 0 : 7, 0.7f);
      float ang = parent.realAngle();
      pushMatrix();
      translate(left.x, left.y, 1);
      rotate(ang);
      ellipse(0, 0, eyeSize, 7);
      popMatrix();
      pushMatrix();
      translate(right.x, right.y, 1);
      rotate(ang);
      ellipse(0, 0, eyeSize, 7);
      popMatrix();
      if (doStache) {
        PVector mid = left.get();
        mid.lerp(right, 0.5f);
        mid.lerp(org, 0.35f);
        pushMatrix();
        translate(mid.x, mid.y, 1);
        rotate(ang +HALF_PI);
        image(stache, -15, 0, 30, 10);
        popMatrix();
      }
    }
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
      if (impulse) n = particles.length - 10;
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
      particles[0][0] = physics.makeParticle(0.2f, tops[0].x, tops[0].y, 0);
      particles[0][1] = physics.makeParticle(0.2f, bots[0].x, bots[0].y, 0);
      fixedParticles[0][0] = physics.makeParticle(0.2f, tops[0].x, tops[0].y, 0);
      fixedParticles[0][1] = physics.makeParticle(0.2f, bots[0].x, bots[0].y, 0);
      fixedParticles[0][0].makeFixed();
      fixedParticles[0][1].makeFixed();
      physics.makeSpring(particles[0][0], fixedParticles[0][0], SPRING_STRENGTH * 0.6f, SPRING_DAMPING, 0);
      physics.makeSpring(particles[0][1], fixedParticles[0][1], SPRING_STRENGTH * 0.6f, SPRING_DAMPING, 0);
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
      particles[x][0] = physics.makeParticle(0.2f, tvx, tvy, 0);
      particles[x][1] = physics.makeParticle(0.2f, bvx, bvy, 0);
      fixedParticles[x][0] = physics.makeParticle(0.2f, tvx, tvy, 0);
      fixedParticles[x][1] = physics.makeParticle(0.2f, bvx, bvy, 0);
      fixedParticles[x][0].makeFixed();
      fixedParticles[x][1].makeFixed();

      physics.makeSpring(particles[x][0], fixedParticles[x][0], SPRING_STRENGTH * 0.6f, SPRING_DAMPING, 0);
      physics.makeSpring(particles[x][1], fixedParticles[x][1], SPRING_STRENGTH * 0.6f, SPRING_DAMPING, 0);
      float d;
      d = particles[x - 1][0].position().distanceTo(particles[x][0].position());
      physics.makeSpring(particles[x - 1][0], particles[x][0], SPRING_STRENGTH * 0.02f, SPRING_DAMPING, d * tension);
      d = particles[x - 1][1].position().distanceTo(particles[x][1].position());
      physics.makeSpring(particles[x - 1][1], particles[x][1], SPRING_STRENGTH * 0.02f, SPRING_DAMPING, d * tension);
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
public class KeyFrame {
  int      time;
  int     track;
  float  rotate;
  float    size;
  KeyFrame next;
  KeyFrame prev;
  int     col;
  boolean first;
  public KeyFrame(int _time, float _rotate, int _track, int _col) {
    time = _time;
    rotate = _rotate;
    track = _track;
    col = _col;
    first = true;
  }
  public KeyFrame(int _time, float _rotate, KeyFrame _prev, int _track, int _col, boolean _first) {
    time = _time;
    rotate = _rotate;
    prev = _prev;
    track = _track;
    col = _col;
    first = _first;
  }
  public KeyFrame(int _time, float _rotate, KeyFrame _prev, int _track, int _col) {
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
      translate(map(time, exerptOff, exerptOff + exerptLen, width / 2, width), (track + 0.5f) * trackHeight);
      rotate(PI / 4);
      noFill();
      strokeWeight(1.5f);
      stroke(h ? 255 : col);
      size = lerp(size, trackHeight * 0.3f, 0.17f);
      rect(0, 0, size, size);
      popMatrix();
    }
    if (next != null) next.draw();
  }
  public boolean hover() {
    return prev != null && dist(mouseX, mouseY, 
                                map(time, exerptOff, exerptOff + exerptLen, width / 2, width),
                                (track + 0.5f) * trackHeight) < trackHeight * 0.4f;
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
      next.size = trackHeight * 0.3f;
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
public class Limb {
  float mag;
  float angle;
  float startAngle;
  int col;
  PVector origin;
  Limb parent;
  JiggleLimb jLimb;
  ArrayList<Limb> children;
  String name;
  boolean update = false;
  boolean h = false;
  public Limb(float _x, float _y, float _mag, float _angle, int _col, String _name) {
    mag    = _mag;
    angle  = _angle;
    startAngle = _angle;
    col    = _col;
    origin = new PVector(_x, _y);
    children = new ArrayList();
    name = _name;
  }
  public Limb(float _mag, float _angle, int _col, String _name, Limb _parent) {
    this(0, 0, _mag, _angle, _col, _name);
    parent = _parent;
    _parent.children.add(this);
  }
  public void draw() {
    pushMatrix();
    if (parent == null) translate(origin.x, origin.y);
    else translate(parent.mag, 0);
    rotate(angle);
    h = (hovered() && focusedLimb == null) || this == focusedLimb;
    if (!inMenu && h) {
      strokeWeight(2);
      stroke(0xffff1111);
      ellipse(mag, 0, 20, 20);
      colorMode(HSB);
      stroke(color((map(dRot, 0, 5*TWO_PI, 0, 255) + 90) % 255, 230, 230));
      colorMode(RGB);
      noFill();
      if (dRot >= 0) arc(0, 0, mag * 2, mag * 2, -dRot, 0);
      else arc(0, 0, mag * 2, mag * 2, 0, -dRot);
      if (mousePressed && !scrubFocus && !doAnim) {
        down = true;
        if (focusedLimb == null) {
          sAngle = angle;
          focusedLimb = this;
        }
        PVector n = new PVector(mouseX - screenX(0, 0, 0), mouseY - screenY(0, 0, 0));
        PVector c = new PVector(screenX(mag, 0, 0) - screenX(0, 0, 0), screenY(mag, 0, 0) - screenY(0, 0, 0));
        if (sign(n.heading()) + sign(pN) == 0 && sign(n.heading() - c.heading()) != sign(pdN) && abs(n.heading()) > 0.5f) {
          dRot += -TWO_PI * sign(n.heading() - c.heading());
        }
        angle += n.heading() - c.heading();
        pN = n.heading();
        pdN = abs(n.heading() - c.heading()) < 0.001f ? 0 : n.heading() - c.heading();
        dRot += pdN;
        move();
      } else {
        focusedLimb = null;
      }
    }
    noFill();
    stroke(h ? lerpColor(col, 0xffffffff, 0.7f) : col);
    strokeWeight(6);
    if (!doAnim) ellipse(mag, 0, 3, 3);
    if (children.size() > 0) {
      for (Limb c : children) c.draw();
    } 
    if (jLimb != null && (update || impulse)) {
      jLimb.update(screenX(0, 0, 0), screenY(0, 0, 0), screenX(mag, 0, 0), screenY(mag, 0, 0), realAngle());
      update = false;
    }
    popMatrix();
  }
  private void move() {
    update = true;
    for (Limb l : children) l.move();
  }
  private boolean hovered() {
    return dist(mouseX, mouseY, screenX(mag, 0, 0), screenY(mag, 0, 0)) < 10;
  }
  public PVector[] realPosition() {
    PVector[] out = new PVector[2];
    if (parent == null) {
      out[0] = origin.get();
    } else {
      out[0] = parent.realPosition()[1].get();
    }
    out[1] = new PVector(mag, 0);
    out[1].rotate(realAngle());
    out[1].add(out[0]);
    return out;
  }
  public float realAngle() {
    if (parent == null) return angle;
    return angle + parent.realAngle();
  }
}

public int sign(float a) {
  if ((int)Math.signum(a) > 0) return 1;
  else if ((int)Math.signum(a) == 0) return 0;
  else return -1;
}
public class Scrubber {
  int loc;
  public Scrubber() {
    
  }
  public void draw() {
    float x = map(loc, exerptOff, exerptOff + exerptLen, width / 2, width);
    stroke(0xffFF0026);
    strokeWeight(1);
    line(x, 0, x, height);
  }
}
public class Song {
  String title;
  String artist;
  String file;
  int bpm;
  int[] offs;
  public Song(String data) {
    String[] bits = data.split(",");
    title = bits[0].trim();
    artist = bits[1].trim();
    file = "Songs/" + bits[2].trim();
    bpm = parseInt(bits[3].trim());
    offs = new int[bits.length - 4];
    for (int i = 0; i < bits.length - 4; i++) {
      offs[i] = parseInt(bits[i + 4].trim());
    }
  }
  public int totalLen() {
    int out = 0;
    for (int i : offs) {
      out += i;
    }
    return out;
  }
  public String toString() {
    return title + " | " + artist + ": " + bpm;
  }
}
/**
  * John here. Not my code. Here's the forum post with the cool dude who did it: 
  * https://forum.processing.org/one/topic/how-to-generate-a-simple-waveform-of-an-entire-sound-file.html
  * This sketch demonstrates two ways to accomplish offline (non-realtime) analysis of an audio file.<br>
  * The first method, which uses an AudioSample, is what you see running.<br>
  * The second method, which uses an AudioRecordingStream and is only available in Minim Beta 2.1.0 and beyond,<br>
  * can be viewed by looking at the offlineAnalysis.pde file.
  * <p>
  * For more information about Minim and additional features, visit http://code.compartmental.net/minim/
  *
  */





float[][] spectra;

public void analyzeUsingAudioSample()
{
   AudioSample jingle = minim.loadSample(curSong.file, 2048);
   
  // get the left channel of the audio as a float array
  // getChannel is defined in the interface BuffereAudio, 
  // which also defines two constants to use as an argument
  // BufferedAudio.LEFT and BufferedAudio.RIGHT
  float[] leftChannel = jingle.getChannel(AudioSample.LEFT);
  
  // then we create an array we'll copy sample data into for the FFT object
  // this should be as large as you want your FFT to be. generally speaking, 1024 is probably fine.
  int fftSize = 1024;
  float[] fftSamples = new float[fftSize];
  FFT fft = new FFT( fftSize, jingle.sampleRate() );
  
  // now we'll analyze the samples in chunks
  int totalChunks = (leftChannel.length / fftSize) + 1;
  
  // allocate a 2-dimentional array that will hold all of the spectrum data for all of the chunks.
  // the second dimension if fftSize/2 because the spectrum size is always half the number of samples analyzed.
  spectra = new float[totalChunks][fftSize/2];
  
  for(int chunkIdx = 0; chunkIdx < totalChunks; ++chunkIdx)
  {
    int chunkStartIndex = chunkIdx * fftSize;
   
    // the chunk size will always be fftSize, except for the 
    // last chunk, which will be however many samples are left in source
    int chunkSize = min( leftChannel.length - chunkStartIndex, fftSize );
   
    // copy first chunk into our analysis array
    arraycopy( leftChannel, // source of the copy
               chunkStartIndex, // index to start in the source
               fftSamples, // destination of the copy
               0, // index to copy to
               chunkSize // how many samples to copy
              );
      
    // if the chunk was smaller than the fftSize, we need to pad the analysis buffer with zeroes        
    if ( chunkSize < fftSize )
    {
      // we use a system call for this
      Arrays.fill( fftSamples, chunkSize, fftSamples.length - 1, 0.0f );
    }
    
    // now analyze this buffer
    fft.forward( fftSamples );
   
    // and copy the resulting spectrum into our spectra array
    for(int i = 0; i < 512; ++i)
    {
      spectra[chunkIdx][i] = fft.getBand(i);
    }
  }
  
  //jingle.close(); 
}
public class Screen {
  ArrayList<TextEvent> textEvents;
  boolean show = false;
  int bgcol;
  float bgsize;
  PImage bgimg;
  int ns;
  public Screen(int _bgcol, PImage _bgimg, int _ns, TextEvent...ts) {
    textEvents = new ArrayList();
    for (TextEvent t : ts) textEvents.add(t);
    bgcol = _bgcol;
    bgsize = 0;
    bgimg = _bgimg;
    ns = _ns;
  }
  public void draw() {
    if (activeScreen != null && activeScreen != this && abs(activeScreen.bgsize - height) < 1) show = false;
    bgsize = lerp(bgsize, show ? height : 0, 0.05f);
    pushMatrix();
    translate(0, 0, 1);
    fill(bgcol);
    noStroke();
    if (bgimg != null) image(bgimg, 0, bgsize - height, width, height);
    else rect(0, 0, width, bgsize);
    translate(0, 0, 1);
    for (TextEvent t : textEvents) t.draw(show && activeScreen == this ? 1 : 0, bgcol);
    popMatrix();
    if (activeScreen == this && ns != -1 && mousePressed && !down) {
      state = ns;
      down = true;
   }
  }
}
public class TextEvent {
  String text;
  float speed;
  PVector start;
  PVector end;
  PVector pos;
  int nextState;
  boolean button, direction, hover = false;
  boolean chooseSong = false;
  float w;
  float h;
  public TextEvent(String _text, float _sx, float _sy, float _ex, float _ey, float _speed, boolean _button, int _ns) {
    text = _text;
    speed = _speed;
    start = new PVector(_sx, _sy);
    pos = new PVector(_sx, _sy);
    end = new PVector(_ex, _ey);
    w = textWidth(_text);
    h = textAscent() + textDescent();
    direction = true;
    button = _button;
    nextState = _ns;
  }
  public TextEvent(String _text, float _sx, float _sy, float _ex, float _ey, float _speed, int _ns) {
    text = _text;
    speed = _speed;
    start = new PVector(_sx, _sy);
    pos = new PVector(_sx, _sy);
    end = new PVector(_ex, _ey);
    w = textWidth(_text);
    h = textAscent() + textDescent();
    button = true;
    direction = true;
    nextState = _ns;
    chooseSong = true;
    if (_ns == -1) nextState = PApplet.parseInt(random(0, songs.size()));
  }
  public void draw(int s, int bgcol) {
    pos.lerp(direction ? end : start, (!direction && speed < 0.04f) ? 0.04f : speed);
    noStroke();
    fill(255);
    direction = s == 1;
    if (button) {
      hover = mouseX < (pos.x + w + 5) && mouseY < (pos.y + h - textAscent()) &&
              mouseX > (pos.x - 5) && mouseY > (pos.y - textAscent() - 5);
      if (hover) {
        curs = true;
        fill(bgcol);
        if (mousePressed && !down) {
          if (!chooseSong) state = nextState;
          else {
            curSong = songs.get(nextState);
            //println(curSong.file);
            player = minim.loadFile(curSong.file, 2048);
            exerptLen = curSong.offs[turn] * 1000;
            state = 2;
          }
          down = true;
        }
      }
      rectMode(CORNER);
      rect(pos.x - 5, pos.y - textAscent() - 5, w + 10, h + 5, 5);
      fill(hover ? 255 : bgcol);
    }
    text(text, pos.x, pos.y);
  }
}
ArrayList<Screen> screens;
TextEvent endGame;
public void stateMachine() {
  switch (state) {
    case -1:
      activeScreen = screens.get(0);
      screens.get(0).show = true;
      inMenu = true;
      break;
    case 0: 
      skip = false;
      side = true;
      globalTime = 2000;
      turn = 0;
      turnStart = 0;
      doAnim = false;
      screens.get(4).show = false;
      activeScreen = screens.get(0);
      screens.get(0).show = true;
      inMenu = true;
      break;
    case 1:
      activeScreen = screens.get(6);
      activeScreen.show = true;
      break;
    case 2:
      screens.get(6).show = false;
      activeScreen = screens.get(1);
      screens.get(1).show = true;
      inMenu = true;
      break;
    case 3:
      for (Screen s : screens) s.show = false;
      impulse = true;
      inMenu = false;
      turnStart = millis();
      state = 4;
      activeScreen = null;
      break;
    case 4:
      if (globalTime < 1 || skip) {
        skip = false;
        doAnim = false;
        if (player.isPlaying()) {
          player.pause();
        }
        state = side ? 5 : 2;
        side = !side;
        exerptOff += curSong.offs[turn++] * 1000;
        scrubber.loc = exerptOff;
        int i = 0;
        for (Limb l : dancer.limbs) {
          frameTracks.get(l).animate(l, scrubber.loc);
          if (frameTracks.get(l).getEnd().time < exerptOff - 500) frameTracks.get(l).add(new KeyFrame(exerptOff - 499, 0, i, l.col));
          frameTracks.get(l).add(new KeyFrame(exerptOff, 0, i++, l.col));
          //exerptOff, exerptOff + exerptLen
          //KeyFrame tail = finalFrames.get(l).getEnd();
          //tail.next = frameTracks.get(l).next;
          //if(frameTracks.get(l).next != null) frameTracks.get(l).next.prev = tail;
          //frameTracks.put(l, new KeyFrame(exerptOff, l.angle, i++, l.col));
        }
        if (turn > curSong.offs.length - 1) state = 9;
        else exerptLen = curSong.offs[turn] * 1000;
      }
      break;
    case 5:
      activeScreen = screens.get(2);
      screens.get(2).show = true;
      inMenu = true;
      break;
    case 6:
      activeScreen = screens.get(3);
      screens.get(3).show = true;
      inMenu = true;
      break;
    case 7:
      activeScreen = screens.get(4);
      screens.get(4).show = true;
      inMenu = true;
      break;
    case 8:
      state = 0;
      //activeScreen = screens.get(5);
      //screens.get(5).show = true;
      //inMenu = true;
      break;
    case 9:
      activeScreen = screens.get(7);
      activeScreen.show = true;
      inMenu = true;
      scrubber.loc = 0;
      player.cue(0);
      exerptOff = 0;
      exerptLen = curSong.totalLen() * 1000;
      //for (Limb l : dancer.limbs) println(frameTracks.get(l));
      animStartTime = millis() - scrubber.loc;
      break;
    case 10:
      for (Screen s : screens) s.show = false;
      if (!player.isPlaying()) player.play();
      doAnim = true;
      break;
  }
  cursor(curs ? HAND : ARROW);
  curs = false;
  for (Screen s : screens) s.draw();
}
public void makeEvents() {
  screens = new ArrayList();
  screens.add(new Screen(0xffEF3C29, loadImage("dance_title_screen.png"), -1,
                         new TextEvent("Start", width - 205, height + 200, width - 205, height - 90, 0.05f, true, 1),
                         new TextEvent("Instructions", width + 200, height - 150, width - 250, height - 150, 0.04f, true, 6)));
  screens.add(new Screen(0xffEF3C29, null, 3,
                         new TextEvent("Animator A's Turn", width / 2 - 120, height + 100, width / 2 - 120, height / 2, 0.04f, false, 3), 
                         new TextEvent("(Click to Continue...)", -900, height / 2 + 50, width / 2 - 140, height / 2 + 50, 0.003f, false, 3)));
  screens.add(new Screen(0xff3E4DCB, null, 3,
                         new TextEvent("Animator B's Turn", width / 2 - 120, height + 100, width / 2 - 120, height / 2, 0.04f, false, 3), 
                         new TextEvent("(Click to Continue...)", width + 900, height / 2 + 50, width / 2 - 140, height / 2 + 50, 0.003f, false, 3)));
  screens.add(new Screen(0xff3E4DCB, loadImage("inst1.png"), 7));
  screens.add(new Screen(0xffEF3C29, loadImage("inst2.png"), 0));
  screens.add(new Screen(0xff76CB3E, loadImage("inst2.png"), 0));
  screens.add(new Screen(0xffEF3C29, null, 0,
                         new TextEvent("Choose Song", width / 2 - 200, height + 100, width / 2 - 200, 70, 0.04f, false, 3)));
  ArrayList<TextEvent> evs = screens.get(screens.size() - 1).textEvents;
  int i = 0;
  for (Song s : songs) {
    evs.add(new TextEvent(s.title, i % 2 == 0 ? width + 400 : -400, 130 + 60 * i, width / 2 - 200, 130 + 60 * i, 0.04f, i));
    i++;
  }
  evs.add(new TextEvent("Random", i % 2 == 0 ? width + 400 : -400, 130 + 60 * i, width / 2 - 200, 130 + 60 * i, 0.04f, -1));
  screens.add(new Screen(0xff76CB3E, null, 10,
                         new TextEvent("All Together Now", width / 2 - 120, height + 100, width / 2 - 120, height / 2, 0.04f, false, 1), 
                         new TextEvent("(Click to Continue...)", width + 900, height / 2 + 50, width / 2 - 140, height / 2 + 50, 0.003f, false, 3)));
  
  activeScreen = screens.get(0);
  endGame = new TextEvent("Quit to Menu", width - 250, height + 200, width - 250, height - 70, 0.02f, true, 0);
}
public void timer() {
  globalTime = MAX_TIME - (millis() - turnStart);
  fill(side ? 0xffEF3C29 : 0xff3E4DCB);
  text(str(globalTime / 60000) + ":" + nf((globalTime / 1000) % 60, 2), 20, 60);
}
  public void settings() {  size(900, 700, P3D);  smooth(16); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "keyframework" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
