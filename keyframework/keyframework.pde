import ddf.minim.*;
import ddf.minim.effects.*;

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
HashMap<Limb, KeyFrame> finalTrack;
float ftWidth, ftX;
float trackHeight;
boolean down;
boolean scrubFocus = false;
//Song Data
Minim minim;
AudioPlayer player;
String curSong;
ArrayList<String> songList;
int songLen = 30000;
int beatLen = 100;
int exerptLen = 5000;
int exerptOff = 0;
//Turn Data
boolean side = true;
int globalTime = 2000;
int turnStart = 0;
int MAX_TIME = 5 * 60000 + 2000;
void setup() {
  size(900, 700, P3D);
  font = loadFont("LeagueGothic-Regular-48.vlw");
  stache = loadImage("stache.png");
  minim = new Minim(this);
  physics = new ParticleSystem(0.1, 0.01);
  setDefaults();
  textFont(font, 48);
  makeEvents();
  smooth(16);
}
void draw() {
  if (random(0, 1) > 0.995 && blink < millis()) blink = millis() + 200;
  background(state > -1 ? 255 : #EF3C29);
  if (state > -1) {
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
    }
  }
  stateMachine();
}
void keyPressed() {
  if (inMenu) return;
  if (key == ' ') {
    if (doAnim) {
      doAnim = false;
    } else {
      scrubber.loc = 0;
      doAnim = true;
      animStartTime = millis();
    }
  } else if (key == 's') {
    doStache = !doStache;
  }
}
void mouseReleased() {
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
void mousePressed() {
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
  trackHeight = 1.0 * height / dancer.limbs.size();
  int i = 0;
  for (Limb l : dancer.limbs) {
    frameTracks.put(l, new KeyFrame(0, l.angle, i++, l.col));
  }
}