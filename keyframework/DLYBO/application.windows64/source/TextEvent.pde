public class Screen {
  ArrayList<TextEvent> textEvents;
  boolean show = false;
  color bgcol;
  float bgsize;
  PImage bgimg;
  int ns;
  public Screen(color _bgcol, PImage _bgimg, int _ns, TextEvent...ts) {
    textEvents = new ArrayList();
    for (TextEvent t : ts) textEvents.add(t);
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
  boolean chooseSong = false;
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
  public TextEvent(String _text, float _sx, float _sy, float _ex, float _ey, float _speed, int _ns) {
    text = _text;
    speed = _speed;
    start = new PVector(_sx, _sy);
    pos = new PVector(_sx, _sy);
    end = new PVector(_ex, _ey);
    w = textWidth(_text);
    h = textAscent() + textDescent();
    button = true;
    direction = true;
    nextState = _ns;
    chooseSong = true;
    if (_ns == -1) nextState = int(random(0, songs.size()));
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
          if (!chooseSong) state = nextState;
          else {
            curSong = songs.get(nextState);
            //println(curSong.file);
            player = minim.loadFile(curSong.file, 2048);
            exerptLen = curSong.offs[turn] * 1000;
            state = 2;
          }
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
TextEvent endGame;
public void stateMachine() {
  switch (state) {
    case -1:
      activeScreen = screens.get(0);
      screens.get(0).show = true;
      inMenu = true;
      break;
    case 0: 
      skip = false;
      side = true;
      globalTime = 2000;
      turn = 0;
      turnStart = 0;
      doAnim = false;
      screens.get(4).show = false;
      activeScreen = screens.get(0);
      screens.get(0).show = true;
      inMenu = true;
      break;
    case 1:
      activeScreen = screens.get(6);
      activeScreen.show = true;
      break;
    case 2:
      screens.get(6).show = false;
      activeScreen = screens.get(1);
      screens.get(1).show = true;
      inMenu = true;
      break;
    case 3:
      for (Screen s : screens) s.show = false;
      impulse = true;
      inMenu = false;
      turnStart = millis();
      state = 4;
      activeScreen = null;
      break;
    case 4:
      if (globalTime < 1 || skip) {
        skip = false;
        doAnim = false;
        if (player.isPlaying()) {
          player.pause();
        }
        state = side ? 5 : 2;
        side = !side;
        exerptOff += curSong.offs[turn++] * 1000;
        scrubber.loc = exerptOff;
        int i = 0;
        for (Limb l : dancer.limbs) {
          frameTracks.get(l).animate(l, scrubber.loc);
          if (frameTracks.get(l).getEnd().time < exerptOff - 500) frameTracks.get(l).add(new KeyFrame(exerptOff - 499, 0, i, l.col));
          frameTracks.get(l).add(new KeyFrame(exerptOff, 0, i++, l.col));
          //exerptOff, exerptOff + exerptLen
          //KeyFrame tail = finalFrames.get(l).getEnd();
          //tail.next = frameTracks.get(l).next;
          //if(frameTracks.get(l).next != null) frameTracks.get(l).next.prev = tail;
          //frameTracks.put(l, new KeyFrame(exerptOff, l.angle, i++, l.col));
        }
        if (turn > curSong.offs.length - 1) state = 9;
        else exerptLen = curSong.offs[turn] * 1000;
      }
      break;
    case 5:
      activeScreen = screens.get(2);
      screens.get(2).show = true;
      inMenu = true;
      break;
    case 6:
      activeScreen = screens.get(3);
      screens.get(3).show = true;
      inMenu = true;
      break;
    case 7:
      activeScreen = screens.get(4);
      screens.get(4).show = true;
      inMenu = true;
      break;
    case 8:
      state = 0;
      //activeScreen = screens.get(5);
      //screens.get(5).show = true;
      //inMenu = true;
      break;
    case 9:
      activeScreen = screens.get(7);
      activeScreen.show = true;
      inMenu = true;
      scrubber.loc = 0;
      player.cue(0);
      exerptOff = 0;
      exerptLen = curSong.totalLen() * 1000;
      //for (Limb l : dancer.limbs) println(frameTracks.get(l));
      animStartTime = millis() - scrubber.loc;
      break;
    case 10:
      for (Screen s : screens) s.show = false;
      if (!player.isPlaying()) player.play();
      doAnim = true;
      break;
  }
  cursor(curs ? HAND : ARROW);
  curs = false;
  for (Screen s : screens) s.draw();
}
public void makeEvents() {
  screens = new ArrayList();
  screens.add(new Screen(#EF3C29, loadImage("dance_title_screen.png"), -1,
                         new TextEvent("Start", width - 205, height + 200, width - 205, height - 90, 0.05, true, 1),
                         new TextEvent("Instructions", width + 200, height - 150, width - 250, height - 150, 0.04, true, 6)));
  screens.add(new Screen(#EF3C29, null, 3,
                         new TextEvent("Animator A's Turn", width / 2 - 120, height + 100, width / 2 - 120, height / 2, 0.04, false, 3), 
                         new TextEvent("(Click to Continue...)", -900, height / 2 + 50, width / 2 - 140, height / 2 + 50, 0.003, false, 3)));
  screens.add(new Screen(#3E4DCB, null, 3,
                         new TextEvent("Animator B's Turn", width / 2 - 120, height + 100, width / 2 - 120, height / 2, 0.04, false, 3), 
                         new TextEvent("(Click to Continue...)", width + 900, height / 2 + 50, width / 2 - 140, height / 2 + 50, 0.003, false, 3)));
  screens.add(new Screen(#3E4DCB, loadImage("inst1.png"), 7));
  screens.add(new Screen(#EF3C29, loadImage("inst2.png"), 0));
  screens.add(new Screen(#76CB3E, loadImage("inst2.png"), 0));
  screens.add(new Screen(#EF3C29, null, 0,
                         new TextEvent("Choose Song", width / 2 - 200, height + 100, width / 2 - 200, 70, 0.04, false, 3)));
  ArrayList<TextEvent> evs = screens.get(screens.size() - 1).textEvents;
  int i = 0;
  for (Song s : songs) {
    evs.add(new TextEvent(s.title, i % 2 == 0 ? width + 400 : -400, 130 + 60 * i, width / 2 - 200, 130 + 60 * i, 0.04, i));
    i++;
  }
  evs.add(new TextEvent("Random", i % 2 == 0 ? width + 400 : -400, 130 + 60 * i, width / 2 - 200, 130 + 60 * i, 0.04, -1));
  screens.add(new Screen(#76CB3E, null, 10,
                         new TextEvent("All Together Now", width / 2 - 120, height + 100, width / 2 - 120, height / 2, 0.04, false, 1), 
                         new TextEvent("(Click to Continue...)", width + 900, height / 2 + 50, width / 2 - 140, height / 2 + 50, 0.003, false, 3)));
  
  activeScreen = screens.get(0);
  endGame = new TextEvent("Quit to Menu", width - 250, height + 200, width - 250, height - 70, 0.02, true, 0);
}