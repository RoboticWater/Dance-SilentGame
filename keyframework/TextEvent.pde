public class Screen {
  TextEvent[] textEvents;
  boolean show = false;
  color bgcol;
  float bgsize;
  PImage bgimg;
  int ns;
  public Screen(color _bgcol, PImage _bgimg, int _ns, TextEvent...ts) {
    textEvents = ts;
    bgcol = _bgcol;
    bgsize = 0;
    bgimg = _bgimg;
    ns = _ns;
  }
  public void draw() {
    if (activeScreen != null && activeScreen != this && abs(activeScreen.bgsize - height) < 1) show = false;
    bgsize = lerp(bgsize, show ? height : 0, 0.05);
    pushMatrix();
    translate(0, 0, 1);
    fill(bgcol);
    noStroke();
    if (bgimg != null) image(bgimg, 0, bgsize - height, width, height);
    else rect(0, 0, width, bgsize);
    translate(0, 0, 1);
    for (TextEvent t : textEvents) t.draw(show && activeScreen == this ? 1 : 0, bgcol);
    popMatrix();
    if (activeScreen == this && ns != -1 && mousePressed && !down) {
      state = ns;
     down = true;
   }
  }
}
public class TextEvent {
  String text;
  float speed;
  PVector start;
  PVector end;
  PVector pos;
  int nextState;
  boolean button, direction, hover = false;
  float w;
  float h;
  public TextEvent(String _text, float _sx, float _sy, float _ex, float _ey, float _speed, boolean _button, int _ns) {
    text = _text;
    speed = _speed;
    start = new PVector(_sx, _sy);
    pos = new PVector(_sx, _sy);
    end = new PVector(_ex, _ey);
    w = textWidth(_text);
    h = textAscent() + textDescent();
    direction = true;
    button = _button;
    nextState = _ns;
  }
  public void draw(int s, color bgcol) {
    pos.lerp(direction ? end : start, (!direction && speed < 0.04) ? 0.04 : speed);
    noStroke();
    fill(255);
    direction = s == 1;
    if (button) {
      hover = mouseX < (pos.x + w + 5) && mouseY < (pos.y + h - textAscent()) &&
              mouseX > (pos.x - 5) && mouseY > (pos.y - textAscent() - 5);
      if (hover) {
        curs = true;
        fill(bgcol);
        if (mousePressed && !down) {
          state = nextState;
          down = true;
        }
      }
      rectMode(CORNER);
      rect(pos.x - 5, pos.y - textAscent() - 5, w + 10, h + 5, 5);
      fill(hover ? 255 : bgcol);
    }
    text(text, pos.x, pos.y);
  }
}
ArrayList<Screen> screens;
public void stateMachine() {
  switch (state) {
    case -1:
      activeScreen = screens.get(0);
      screens.get(0).show = true;
      inMenu = true;
      break;
    case 0: 
      screens.get(4).show = false;
      activeScreen = screens.get(0);
      screens.get(0).show = true;
      inMenu = true;
      break;
    case 1: 
      activeScreen = screens.get(1);
      screens.get(1).show = true;
      inMenu = true;
      break;
    case 2:
      for (Screen s : screens) s.show = false;
      impulse = true;
      inMenu = false;
      turnStart = millis();
      state = 3;
      activeScreen = null;
      break;
    case 3:
      if (globalTime < 1) {
        state = side ? 4 : 1;
        side = !side;
      }
      break;
    case 4:
      activeScreen = screens.get(2);
      screens.get(2).show = true;
      inMenu = true;
      break;
    case 5:
      activeScreen = screens.get(3);
      screens.get(3).show = true;
      inMenu = true;
      break;
    case 6:
      activeScreen = screens.get(4);
      screens.get(4).show = true;
      inMenu = true;
      break;
  }
  cursor(curs ? HAND : ARROW);
  curs = false;
  for (Screen s : screens) s.draw();
}
public void makeEvents() {
  screens = new ArrayList();
  screens.add(new Screen(#EF3C29, loadImage("dance_title_screen.png"), -1,
                         new TextEvent("Start", width - 150, height + 200, width - 150, height - 90, 0.05, true, 1),
                         new TextEvent("Instructions", width + 200, height - 150, width - 190, height - 150, 0.04, true, 5)));
  screens.add(new Screen(#EF3C29, null, 2,
                         new TextEvent("Animator A's Turn", width / 2 - 120, height + 100, width / 2 - 120, height / 2, 0.04, false, 3), 
                         new TextEvent("(Click to Continue...)", -900, height / 2 + 50, width / 2 - 140, height / 2 + 50, 0.003, false, 3)));
  screens.add(new Screen(#3E4DCB, null, 2,
                         new TextEvent("Animator B's Turn", width / 2 - 120, height + 100, width / 2 - 120, height / 2, 0.04, false, 3), 
                         new TextEvent("(Click to Continue...)", width + 900, height / 2 + 50, width / 2 - 140, height / 2 + 50, 0.003, false, 3)));
  screens.add(new Screen(#3E4DCB, null, 6,
                         new TextEvent("Animators", -500, 100, 50, 100, 0.04, false, 3), 
                         new TextEvent("(Click to Continue...)", width + 900, height -100, width - 350, height - 100, 0.04, false, 3)));
  screens.add(new Screen(#76CB3E, null, 0,
                         new TextEvent("Observer", 50, height + 100, 50, 100, 0.04, false, 3), 
                         new TextEvent("(Click to Continue...)", -300, height -100, width - 350, height - 100, 0.02, false, 3)));
  
  activeScreen = screens.get(0);
}