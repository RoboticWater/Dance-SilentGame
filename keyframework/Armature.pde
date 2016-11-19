public class Armature {
  HashMap<String, Limb> limbs;
  public Armature() {
    limbs = new HashMap();
    limbs.put("Chest Lower", new Limb(width / 2, height / 2 + 60, 60, -HALF_PI, #8E57C9, "Chest Lower"));
    limbs.put("Chest Upper", new Limb(70, 0, #4241BC, "Chest Upper", limbs.get("Chest Lower")));
    limbs.put("Neck", new Limb(30, 0, #7EE838, "Neck", limbs.get("Chest Upper")));
    limbs.put("Head", new Limb(30, 0, #E83858, "Head", limbs.get("Neck")));
    limbs.put("Right Shoulder", new Limb(50, HALF_PI, #C7E838, "Right Shoulder", limbs.get("Chest Upper")));
    //limbs.put("Right Shoulder", new Limb(300, 300, 50, 0, #000000));
    limbs.put("Right Upper Arm", new Limb(70, HALF_PI, #E8C238, "Right Upper Arm", limbs.get("Right Shoulder")));
    limbs.put("Right Fore Arm", new Limb(60, 0, #E83E38, "Right Fore Arm", limbs.get("Right Upper Arm")));
    limbs.put("Right Hand", new Limb(20, 0, #387DE8, "Right Hand", limbs.get("Right Fore Arm")));
    limbs.put("Left Shoulder", new Limb(50, -HALF_PI, #E8388D, "Left Shoulder", limbs.get("Chest Upper")));
    limbs.put("Left Upper Arm", new Limb(70, -HALF_PI, #E8C238, "Left Upper Arm", limbs.get("Left Shoulder")));
    limbs.put("Left Fore Arm", new Limb(60, 0, #E83E38, "Left Fore Arm", limbs.get("Left Upper Arm")));
    limbs.put("Left Hand", new Limb(20, 0, #387DE8, "Left Hand", limbs.get("Left Fore Arm")));
    limbs.put("Tail", new Limb(width / 2, height / 2 + 60, 10, HALF_PI, #000000, "Tail"));
    limbs.put("Right Hip", new Limb(30, HALF_PI, #38AFE8, "Right Hip", limbs.get("Tail")));
    limbs.put("Right Thigh", new Limb(70, -HALF_PI, #E8388A, "Right Thigh", limbs.get("Right Hip")));
    limbs.put("Right Leg", new Limb(75, 0, #D0E838, "Right Leg", limbs.get("Right Thigh")));
    limbs.put("Right Foot", new Limb(20, PI/6, #E8CE38, "Right Foot", limbs.get("Right Leg")));
    limbs.put("Left Hip", new Limb(30, -HALF_PI, #E1E838, "Left Hip", limbs.get("Tail")));
    limbs.put("Left Thigh", new Limb(70, HALF_PI, #E8388A, "Left Thigh", limbs.get("Left Hip")));
    limbs.put("Left Leg", new Limb(75, 0, #D0E838, "Left Leg", limbs.get("Left Thigh")));
    limbs.put("Left Foot", new Limb(20, -PI/6, #E8CE38, "Left Foot", limbs.get("Left Leg")));
  }
  public void draw() {
    //limbs.get("Chest Upper").draw();
    limbs.get("Chest Lower").draw();
    limbs.get("Tail").draw();
    //limbs.get("Right Shoulder").draw();
  }
}