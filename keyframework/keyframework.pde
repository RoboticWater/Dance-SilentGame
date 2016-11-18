//Default Values
int DEFAULT_KEYFRAME_LENGTH = 1000; //in milliseconds
//Current Frame Data
float dRot;
float sAngle;
//Animating Data
float animStartTime;
//Focus Pointers
Limb                focusedLimb;
ArrayList<KeyFrame> focusedFrame;
//Dancer
Armature dancer;
//FrameTrack
FrameTrack frameTrack = new FrameTrack();
void settings() {
  size(640, 480, P3D);
  String[] args = {"Frame Track"};
  PApplet.runSketch(args, frameTrack);
  setDefaults();
}
void draw() {
  dancer.draw();
}
public void setDefaults() {
  //Current Frame Data
  dRot   = 0;
  sAngle = 0;
  //Focus Pointers
  focusedLimb  = null;
  focusedFrame = new ArrayList();
  //Dancer
  dancer = new Armature();
  //FrameTrack Variables
  frameTrack.frameTracks = new KeyFrame[dancer.limbs.size()];
}