import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:habit_stacker/habit.dart';

class HabitStack {
  List<Habit> habits;
  String name;
  int duration;
  String desc;
  List<int> time;

  HabitStack(this.habits, this.name, this.duration, this.time,
      [this.desc = ""]);

  Map toJson() {
    List<Map> habits = this.habits.map((i) => i.toJson()).toList();
    return {
      'habits': habits,
      'name': name,
      'duration': duration,
      'time': time,
      'desc': desc
    };
  }

  factory HabitStack.fromJson(dynamic json) {
    if (json['habits'] != null) {
      var habitObjsJson = json['habits'] as List;
      List<Habit> _habits =
          habitObjsJson.map((habitJson) => Habit.fromJson(habitJson)).toList();
      var _time = json['time'].cast<int>();
      return HabitStack(
        _habits,
        json['name'] as String,
        json['duration'] as int,
        _time,
        json['desc'] as String,
      );
    } else {
      return HabitStack(
        [] as List<Habit>,
        json['name'] as String,
        json['duration'] as int,
        json['time'] as List<int>,
        json['desc'] as String,
      );
    }
  }
}
