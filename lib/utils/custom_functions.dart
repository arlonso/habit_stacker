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

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

extension TimeOfDayExtension on TimeOfDay {
  // Ported from org.threeten.bp;
  TimeOfDay plusMinutes(int minutes) {
    if (minutes == 0) {
      return this;
    } else {
      int mofd = this.hour * 60 + this.minute;
      int newMofd = ((minutes % 1440) + mofd + 1440) % 1440;
      if (mofd == newMofd) {
        return this;
      } else {
        int newHour = newMofd ~/ 60;
        int newMinute = newMofd % 60;
        return TimeOfDay(hour: newHour, minute: newMinute);
      }
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
