String intToTimeLeft(int value) {
  int m, s;

  m = value ~/ 60;

  s = value - (m * 60);

  String minuteLeft =
      m.toString().length < 2 ? "0" + m.toString() : m.toString();

  String secondsLeft =
      s.toString().length < 2 ? "0" + s.toString() : s.toString();

  String result = "$minuteLeft:$secondsLeft";

  return result;
}
