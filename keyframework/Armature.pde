public class Armature {
  HashMap<String, Limb> limbs;
  public Armature() {
    limbs = new HashMap();
    limbs.put("Chest Lower", new Limb(width / 2, height / 2 + 70, 70, -HALF_PI, #00ff00));
    limbs.put("Chest Upper", new Limb(70, 0, #0000ff, limbs.get("Chest Lower")));
    limbs.put("Right Shoulder", new Limb(50, HALF_PI, #000000, limbs.get("Chest Upper")));
    //limbs.put("Right Shoulder", new Limb(300, 300, 50, 0, #000000));
    limbs.put("Right Upper Arm", new Limb(70, HALF_PI, #ff0000, limbs.get("Right Shoulder")));
    limbs.put("Right Fore Arm", new Limb(60, 0, #00ff00, limbs.get("Right Upper Arm")));
    limbs.put("Right Hand", new Limb(20, 0, #0000ff, limbs.get("Right Fore Arm")));
    limbs.put("Left Shoulder", new Limb(50, -HALF_PI, #000000, limbs.get("Chest Upper")));
    limbs.put("Left Upper Arm", new Limb(70, -HALF_PI, #ff0000, limbs.get("Left Shoulder")));
    limbs.put("Left Fore Arm", new Limb(60, 0, #00ff00, limbs.get("Left Upper Arm")));
    limbs.put("Left Hand", new Limb(20, 0, #0000ff, limbs.get("Left Fore Arm")));
  }
  public void draw() {
    //limbs.get("Chest Upper").draw();
    limbs.get("Chest Lower").draw();
    //limbs.get("Right Shoulder").draw();
  }
}