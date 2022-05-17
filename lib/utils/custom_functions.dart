import 'package:flutter/material.dart';

String intToTimeString(int value) {
  int h, m, s;
  String result = "";

  h = value ~/ 3600;

  m = ((value - h * 3600)) ~/ 60;

  s = value - (h * 3600) - (m * 60);

  String hoursLeft =
      h.toString().length < 2 ? "0" + h.toString() : h.toString();

  String minutesLeft =
      m.toString().length < 2 ? "0" + m.toString() : m.toString();

  String secondsLeft =
      s.toString().length < 2 ? "0" + s.toString() : s.toString();

  if (h > 0) {
    result = "$hoursLeft:$minutesLeft:$secondsLeft";
  } else if (m > 0) {
    result = "$minutesLeft:$secondsLeft";
  } else {
    result = secondsLeft;
  }

  return result;
}

double toDouble(List<int> myTime) => myTime[0] + myTime[1] / 60.0;
