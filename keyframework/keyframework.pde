//Current Frame Data
float dRot;
float pN;
float pdN;
float sAngle;
//Animating Data
float animStartTime;
//Focus Pointers
Limb                focusedLimb;
ArrayList<KeyFrame> focusedFrames;
//Objects
Armature dancer;
Scrubber scrubber;
//FrameTrack
FrameTrack frameTrack = new FrameTrack();
//Song Data

void settings() {
  size(640, 480, P3D);
  String[] args = {"Frame Track"};
  PApplet.runSketch(args, frameTrack);
  setDefaults();
}
void draw() {
  background(255);
  dancer.draw();
}
void mouseReleased() {
  if (focusedLimb != null) {
    focusedLimb = null;
    println(dRot);
    dRot = 0;
    pN   = 0;
    pdN  = 0;
  }
}
public void setDefaults() {
  //Current Frame Data
  dRot   = 0;
  sAngle = 0;
  //Focus Pointers
  focusedLimb  = null;
  focusedFrame = new ArrayList();
  //Objects
  dancer = new Armature();
  scrubber = new Scrubber();
  //FrameTrack Variables
  frameTrack.frameTracks = new KeyFrame[dancer.limbs.size()];
  frameTrack.tHeight = frameTrack.height / dancer.limbs.size();
  int i = 0;
  for (String n : dancer.limbs.keySet()) {
    frameTrack.frameTracks[i++] = new KeyFrame(0, dancer.limbs.get(n).angle);
  }
}