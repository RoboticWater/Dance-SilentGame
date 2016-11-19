//Current Frame Data
float dRot;
float pN;
float pdN;
float sAngle;
//Animating Data
float   animStartTime;
boolean doAnim;
//Focus Pointers
Limb                focusedLimb;
ArrayList<KeyFrame> focusedFrames;
//Objects
Armature dancer;
Scrubber scrubber;
//FrameTrack
FrameTrack frameTrack = new FrameTrack();
//Song Data
int songLen = 30000; //In milliseconds
int beatLen = 500;   //In milliseconds
void settings() {
  size(640, 480, P3D);
  setDefaults();
  String[] args = {"Frame Track"};
  PApplet.runSketch(args, frameTrack);
  setDefaults();
}
void draw() {
  background(255);
  dancer.draw();
  //println(scrubber.loc);
    //println(dRot);
}
void mouseReleased() {
  if (focusedLimb != null) {
    frameTrack.frameTracks.get(focusedLimb).add(scrubber.loc, dRot);
    dRot = 0;
    pN   = 0;
    pdN  = 0;
    focusedLimb = null;
  }
}
public void setDefaults() {
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
  dancer = new Armature();
  scrubber = new Scrubber();
  //FrameTrack Variables
  frameTrack.frameTracks = new HashMap();
  for (String n : dancer.limbs.keySet()) {
    frameTrack.frameTracks.put(dancer.limbs.get(n), new KeyFrame(0, dancer.limbs.get(n).angle));
  }
  frameTrack.tHeight = frameTrack.height / dancer.limbs.size();
}