ArrayList<Armature> armatures;
HashMap<Armature, ArrayList<Keyframe>> tracks;
HashMap<Armature, Integer> curKeyframe;
Armature focus;
Keyframe kFocus;
float start, end;
boolean animate = false;
int animateStart = 0;
int revs = 0;
float pN, pdN;
float dRot = 0;
float scrubberX = 0;
float trackSize = 20;
int totalTime = 10;
float step = 4;
void setup() {
  size(640, 480, P3D);
  smooth(8);
  strokeWeight(2);
  armatures = new ArrayList();
  tracks = new HashMap();
  curKeyframe = new HashMap();
  
  armatures.add(new Armature(300, 300, 75, 0));
  tracks.put(armatures.get(armatures.size() - 1), new ArrayList());
  curKeyframe.put(armatures.get(armatures.size() - 1), null);
  
  armatures.add(new Armature(armatures.get(0), 75, 0));
  tracks.put(armatures.get(armatures.size() - 1), new ArrayList());
  curKeyframe.put(armatures.get(armatures.size() - 1), null);
  
  armatures.add(new Armature(armatures.get(1), 20, 0));
  tracks.put(armatures.get(armatures.size() - 1), new ArrayList());
  curKeyframe.put(armatures.get(armatures.size() - 1), null);

  
}
void draw() {
  background(255);
  if (mouseY < armatures.size() * trackSize && mousePressed) {
    scrubberX = int(mouseX / (width / (totalTime * step)))* (width / (totalTime * step));
  }
  //println(dRot);
  if (animate) {
    for (int i = 0; i < armatures.size(); i++) {
      Armature a = armatures.get(i);
      int cki = curKeyframe.get(a);
      if (cki == -1) continue;
      //println(i);
      Keyframe ck = tracks.get(a).get(cki);
      //float r = map(millis() - animateStart, ck.sTime, ck.eTime, ck.sAnim, ck.eAnim);
      float r = (millis() - animateStart - ck.sTime) * ck.vAnim + ck.sAnim;
      if (millis() - animateStart > ck.eTime) {
        curKeyframe.put(a, cki + 1 < tracks.get(a).size() ? cki + 1 : -1);
        a.animate(ck.eAnim);
        continue;
      }
      a.animate(r);
    }
  }
  pushMatrix();
  armatures.get(0).draw();
  popMatrix();
  for(int i = 0; i < armatures.size(); i++) {
    stroke(0);
    fill(255);
    rect(0, i * trackSize, width, trackSize);
    for (Keyframe k : tracks.get(armatures.get(i))) {
      k.draw(i);
    }
  }
  //println("----");
  //for (Armature a : tracks.keySet()) {
  //  println(tracks.get(a).size());
  //}
  stroke(#ff0000);
  line(scrubberX, 0, scrubberX, armatures.size() * 20);
}
void mouseReleased() {
  if(focus != null && abs(start - focus.angle) > 0.1) {
    end = dRot;
    println(dRot);
    ArrayList<Keyframe> t = tracks.get(focus);
    //IMPLEMENT SCRUBBER OFFSET
    t.add(new Keyframe(t.size() == 0 ? 0 : t.get(t.size() - 1).eAnim,
                       end,
                       t.size() == 0 ? 0 : t.get(t.size() - 1).eTime));
  }
  dRot = 0;
  pN = 0;
  pdN = 0;
}
void keyPressed() {
  if (key == ' ') {
    animate = true;
    animateStart = millis();
    for (Armature a : armatures) {
      curKeyframe.put(a, tracks.get(a).size() == 0 ? -1 : 0);
    }
  }
}