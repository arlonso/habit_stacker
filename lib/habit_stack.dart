import 'dart:convert';

import 'Habit.dart';

class HabitStack {
  List<Habit> habits;
  String name;
  int duration;
  String desc;

  HabitStack(this.habits, this.name, this.duration, [this.desc = ""]);

  Map toJson() {
    List<Map> habits = this.habits.map((i) => i.toJson()).toList();
    return {'habits': habits, 'name': name, 'duration': duration, 'desc': desc};
  }

  factory HabitStack.fromJson(dynamic json) {
    if (json['habits'] != null) {
      var habitObjsJson = json['habits'] as List;
      List<Habit> _habits =
          habitObjsJson.map((habitJson) => Habit.fromJson(habitJson)).toList();
      return HabitStack(
        _habits,
        json['name'] as String,
        json['duration'] as int,
        json['desc'] as String,
      );
    } else {
      return HabitStack(
        [] as List<Habit>,
        json['name'] as String,
        json['duration'] as int,
        json['desc'] as String,
      );
    }
  }
}
