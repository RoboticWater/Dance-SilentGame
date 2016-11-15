ArrayList<Armature> armatures;
HashMap<Armature, ArrayList<Keyframe>> tracks;
HashMap<Armature, Integer> curKeyframe;
Armature focus;
float start, end;
boolean animate = false;
int animateStart = 0;
float flarp = 0;
float dRot = 0;
PVector p = new PVector(20, 0);
void setup() {
  size(640, 480);
  smooth();
  armatures = new ArrayList();
  tracks = new HashMap();
  curKeyframe = new HashMap();
  
  armatures.add(new Armature(300, 300, 100, PI));
  tracks.put(armatures.get(armatures.size() - 1), new ArrayList());
  curKeyframe.put(armatures.get(armatures.size() - 1), null);
  
  //armatures.add(new Armature(armatures.get(0), 50, PI));
  //tracks.put(armatures.get(armatures.size() - 1), new ArrayList());
  //curKeyframe.put(armatures.get(armatures.size() - 1), null);
  
  //armatures.add(new Armature(armatures.get(1), 50, PI));
  //tracks.put(armatures.get(armatures.size() - 1), new ArrayList());
  //curKeyframe.put(armatures.get(armatures.size() - 1), null);

  
}
void draw() {

  background(255);
  p.rotate(dRot);
  line(100, 100, 100 + p.x, 100+ p.y);
  p = new PVector(20, 0);
  //flarp += 0.01;
  //armatures.get(0).animate(armatures.get(0).org, flarp);
  if (animate) {
    for (int i = 0; i < armatures.size(); i++) {
      Armature a = armatures.get(i);
      int cki = curKeyframe.get(a);
      if (cki == -1) continue;
      //println(i);
      Keyframe ck = tracks.get(a).get(cki);
      float r = map(millis() - animateStart, ck.sTime, ck.eTime, ck.sAnim, ck.eAnim);
      //println(cki);
      //println(millis() - animateStart + " " + ck.sTime + " " + ck.eTime);
      //println(ck.sAnim + " " + ck.eAnim + " " + r + " " + abs(r - ck.eAnim));
      //println("=========");
      if (millis() - animateStart > ck.eTime) {
        curKeyframe.put(a, cki + 1 < tracks.get(a).size() ? cki + 1 : -1);
        a.animate(a.org, ck.eAnim, ck.dir);
        continue;
      }
      a.animate(a.org, r, ck.dir);
    }
  }
  armatures.get(0).draw();
  for(int i = 0; i < armatures.size(); i++) {
    stroke(0);
    fill(255);
    rect(0, i * 20, width, 20);
    for (Keyframe k : tracks.get(armatures.get(i))) {
      k.draw(i * 20);
    }
  }
  //println("----");
  //for (Armature a : tracks.keySet()) {
  //  println(tracks.get(a).size());
  //}
}
void mouseReleased() {
  if(abs(start - focus.ext.heading()) > 0.1) {
    end = focus.ext.heading();
    ArrayList<Keyframe> t = tracks.get(focus);
    t.add(new Keyframe(start, end, t.size() == 0 ? 0 : t.get(t.size() - 1).eTime, dRot > 0 ? -1 : 1));
  }
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