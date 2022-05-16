class Habit {
  String name;
  int duration;
  String desc;
  Map<String, dynamic>? icon;

  Habit(
    this.name,
    this.duration, [
    this.desc = "",
    this.icon = const {'pack': "material", 'key': 'task'},
  ]);

  Map toJson() {
    return {'name': name, 'duration': duration, 'desc': desc, 'icon': icon};
  }

  factory Habit.fromJson(dynamic json) {
    return Habit(
      json['name'] as String,
      json['duration'] as int,
      json['desc'] as String,
      json['icon'] as Map<String, dynamic>?,
    );
  }
}
