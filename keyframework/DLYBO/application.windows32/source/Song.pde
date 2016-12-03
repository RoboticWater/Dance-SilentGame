public class Song {
  String title;
  String artist;
  String file;
  int bpm;
  int[] offs;
  public Song(String data) {
    String[] bits = data.split(",");
    title = bits[0].trim();
    artist = bits[1].trim();
    file = "Songs/" + bits[2].trim();
    bpm = parseInt(bits[3].trim());
    offs = new int[bits.length - 4];
    for (int i = 0; i < bits.length - 4; i++) {
      offs[i] = parseInt(bits[i + 4].trim());
    }
  }
  public int totalLen() {
    int out = 0;
    for (int i : offs) {
      out += i;
    }
    return out;
  }
  public String toString() {
    return title + " | " + artist + ": " + bpm;
  }
}