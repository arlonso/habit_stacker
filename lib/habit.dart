class Habit {
  String name;
  int duration;
  String desc;

  Habit(this.name, this.duration, [this.desc = ""]);

  Map toJson() => {'name': name, 'duration': duration, 'desc': desc};

  factory Habit.fromJson(dynamic json) {
    return Habit(json['name'] as String, json['duration'] as int,
        json['desc'] as String);
  }
}
