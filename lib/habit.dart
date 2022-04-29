class Habit {
  String name;
  int duration;
  String desc;
  int? iconCode;
  String? fontFamily;

  Habit(this.name, this.duration,
      [this.desc = "",
      this.iconCode = 0xe645,
      this.fontFamily = 'MaterialIcons']);

  Map toJson() => {'name': name, 'duration': duration, 'desc': desc};

  factory Habit.fromJson(dynamic json) {
    return Habit(
        json['name'] as String,
        json['duration'] as int,
        json['desc'] as String,
        json['iconCode'] as int?,
        json['fontFamily'] as String?);
  }
}
