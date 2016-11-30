public class TextEvent {
  String text;
  float speed;
  PVector start;
  PVector end;
  PVector pos;
  int activeState, nextState;
  boolean button, direction, hover = false;
  float w;
  float h;
  public TextEvent(String _text, float _sx, float _sy, float _ex, float _ey, float _speed, boolean _button, int _as, int _ns) {
    text = _text;
    speed = _speed;
    start = new PVector(_sx, _sy);
    pos = new PVector(_sx, _sy);
    end = new PVector(_ex, _ey);
    w = textWidth(_text);
    h = textAscent() + textDescent();
    direction = true;
    button = _button;
    activeState = _as;
    nextState = _ns;
  }
  public void draw() {
    if (state != activeState && state <= nextState + 1) return;
    pos.lerp(direction ? end : start, speed);
    noStroke();
    fill(255);
    if (direction != (state == activeState)) direction = state == activeState;
    if (button && state == activeState) {
      hover = mouseX < (pos.x + w + 5) && mouseY < (pos.y + h - textAscent()) &&
              mouseX > (pos.x - 5) && mouseY > (pos.y - textAscent() - 5);
      if (hover) {
        fill(bgcol);
        if (mousePressed && !down) {
          state = nextState;
          down = true;
        }
      }
      rect(pos.x - 5, pos.y - textAscent() - 5, w + 10, h + 5, 5);
      fill(hover ? 255 : bgcol);
    }
    text(text, pos.x, pos.y);
  }
}
ArrayList<TextEvent> events;
public void stateMachine() {
  switch (state) {
    case 0: 
      image(bgimg, 0, 0, width, height);
      bgsize = 0;
      bgcol = #EF3C29;
      break;
    case 1:
      translate(0, 0, 1);
      fill(bgcol);
      noStroke();
      rect(0, 0, width, bgsize);
      bgsize = lerp(bgsize, height, 0.05);
      if (mousePressed && !down) state = 3;
      break;
    case 2:
      break;
    case 3:
      break;
  }
  boolean curs = false;
  for (TextEvent e : events) {
    e.draw();
    if (e.hover) curs = true;
  }
  cursor(curs ? HAND : ARROW);
}
public void makeEvents() {
  events = new ArrayList();
  events.add(new TextEvent("Start", width - 150, height + 200, width - 150, height - 90, 0.05, true, 0, 1));
  events.add(new TextEvent("Instructions", width + 200, height - 150, width - 190, height - 150, 0.04, true, 0, 4));
  events.add(new TextEvent("Animator A's Turn", width / 2 - 120, height + 100, width / 2 - 120, height / 2, 0.04, false, 1, 3));
  events.add(new TextEvent("(Click to Continue...)", -900, height / 2 + 50, width / 2 - 140, height / 2 + 50, 0.003, false, 1, 3));
}