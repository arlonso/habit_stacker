import 'package:habit_stacker/habit.dart';

typedef HabitStackChangedCallback = Function(
    Habit habit, int oldDuration, bool inStack, bool toBeDeleted);
