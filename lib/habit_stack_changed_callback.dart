import 'Habit.dart';

typedef HabitStackChangedCallback = Function(
    Habit habit, int oldDuration, bool inStack, bool toBeDeleted);
