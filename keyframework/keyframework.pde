//Screen
PFont font;
int state;
color bgcol = #EF3C29;
float bgsize;
PImage bgimg;
boolean inMenu = true;
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
int songLen = 30000;
int beatLen = 100;
int exerptLen = 5000;
int exerptOff = 0;
void setup() {
  size(900, 700, P3D);
  bgimg = loadImage("dance_title_screen.png");
  font = loadFont("LeagueGothic-Regular-48.vlw");
  physics = new ParticleSystem(0.1, 0.01);
  setDefaults();
  //String[] args = {"Frame Track"};
  //PApplet.runSketch(args, frameTrack);
  setDefaults();
  textFont(font, 48);
  makeEvents();
}
void draw() {
  background(255);
  frameTrack();
  //stateMachine();
  for (JiggleLimb j : jLimbs) {
    j.draw();
  }
  dancer.draw();
  physics.tick();
  if (doAnim) scrubber.loc = millis() - animStartTime;
  //fill(bgcol);
  //noStroke();
  //translate(0, 0, 1);
  //rect(0, 0, width, bgsize);
  //bgsize = lerp(bgsize, -1, 0.05);
}
void keyPressed() {
  if (key == ' ') {
    if (doAnim) {
      doAnim = false;
    } else {
      scrubber.loc = 0;
      doAnim = true;
      animStartTime = millis();
    }
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
  //if (mouseX > width - 15 - tHeight / 2) {
  //  //frameTracks.get().add(scrubber.loc, 0);
  //}
}
public void setDefaults() {
  //Screen
  state = 0;
  bgsize = height;
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
  for (Limb n : dancer.limbs) {
    frameTracks.put(n, new KeyFrame(0, n.angle));
  }
}