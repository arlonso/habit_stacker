import 'package:flutter/material.dart';

import 'Habit.dart';
import 'habit_stack_changed_callback.dart';

class HabitStackItem extends StatelessWidget {
  HabitStackItem({
    required this.index,
    required this.habit,
    required this.inStack,
    required this.onHabitStackChanged,
  }) : super(key: ObjectKey(habit));

  final int index;
  final Habit habit;
  final bool inStack;
  final HabitStackChangedCallback onHabitStackChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text((index + 1).toString()),
      ),
      title: Text(
        habit.name,
      ),
      subtitle: Text('${habit.duration.toString()} min'),
      trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onHabitStackChanged(habit, inStack)),
    );
  }
}
