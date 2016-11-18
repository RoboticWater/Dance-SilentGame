public class Armature {
  HashMap<String, Limb> limbs;
  public Armature() {
    limbs = new HashMap();
    limbs.put("Right Shoulder", new Limb(width / 2, height / 2 - 100, 50, 0, #000000));
    limbs.put("Right Upper Arm", new Limb(70, HALF_PI, #ff0000, limbs.get("Right Shoulder")));
    limbs.put("Right Fore Arm", new Limb(60, 0, #00ff00, limbs.get("Right Upper Arm")));
    limbs.put("Right Hand", new Limb(20, 0, #0000ff, limbs.get("Right Fore Arm")));
    limbs.put("Left Shoulder", new Limb(width / 2, height / 2 - 100, 30, PI, #000000));
    limbs.put("Left Upper Arm", new Limb(70, -HALF_PI, #ff0000, limbs.get("Left Shoulder")));
    limbs.put("Left Fore Arm", new Limb(60, 0, #00ff00, limbs.get("Left Upper Arm")));
    limbs.put("Left Hand", new Limb(20, 0, #0000ff, limbs.get("Left Fore Arm")));
  }
  public void draw() {
    limbs.get("Right Shoulder").draw();
  }
}