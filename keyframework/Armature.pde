public class Armature {
  ArrayList<Limb> limbs;
  public Armature() {
    limbs = new ArrayList();
    limbs.add(new Limb(width / 4, height / 2 + 60, 60, -HALF_PI, #8E57C9, "Chest Lower"));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), null, 40, 50, 5));
    limbs.add(new Limb(width / 4, height / 2 + 60, 10, HALF_PI, #000000, "Tail"));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), null, 40, 45, 2));
    limbs.add(new Limb(70, 0, #4241BC, "Chest Upper", limbs.get(0)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(0), 50, 60, 5));
    limbs.add(new Limb(30, 0, #7EE838, "Neck", limbs.get(2)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 50, 40, 5));
    limbs.add(new Limb(30, 0, #E83858, "Head", limbs.get(3)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 40, 30, 5));
    limbs.add(new Limb(50, HALF_PI, #C7E838, "Right Shoulder", limbs.get(2)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), null, 35, 25, 5));
    //limbs.add(new Limb(300, 300, 50, 0, #000000));
    limbs.add(new Limb(70, HALF_PI, #E8C238, "Right Upper Arm", limbs.get(5)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 25, 25, 5));
    limbs.add(new Limb(60, 0, #E83E38, "Right Fore Arm", limbs.get(6)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 25, 20, 5));
    limbs.add(new Limb(20, 0, #387DE8, "Right Hand", limbs.get(7)));
    jLimbs.add(new JiggleLimb(limbs.get(limbs.size() - 1), jLimbs.get(jLimbs.size() - 1), 20, 13, 4));
    limbs.add(new Limb(50, -HALF_PI, #E8388D, "Left Shoulder", limbs.get(2)));
    limbs.add(new Limb(70, -HALF_PI, #E8C238, "Left Upper Arm", limbs.get(9)));
    limbs.add(new Limb(60, 0, #E83E38, "Left Fore Arm", limbs.get(10)));
    limbs.add(new Limb(20, 0, #387DE8, "Left Hand", limbs.get(11)));
    limbs.add(new Limb(30, HALF_PI, #38AFE8, "Right Hip", limbs.get(1)));
    limbs.add(new Limb(70, -HALF_PI, #E8388A, "Right Thigh", limbs.get(13)));
    limbs.add(new Limb(75, 0, #D0E838, "Right Leg", limbs.get(14)));
    limbs.add(new Limb(20, PI/6, #E8CE38, "Right Foot", limbs.get(15)));
    limbs.add(new Limb(30, -HALF_PI, #E1E838, "Left Hip", limbs.get(1)));
    limbs.add(new Limb(70, HALF_PI, #E8388A, "Left Thigh", limbs.get(17)));
    limbs.add(new Limb(75, 0, #D0E838, "Left Leg", limbs.get(18)));
    limbs.add(new Limb(20, -PI/6, #E8CE38, "Left Foot", limbs.get(19)));
  }
  public void draw() {
    limbs.get(0).draw();
    limbs.get(1).draw();
  }
}