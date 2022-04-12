import 'package:flutter/material.dart';

import 'Habit.dart';
import 'habit_stack_changed_callback.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    return Slidable(
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              flex: 1,
              onPressed: (context) => onHabitStackChanged(habit, inStack),
              backgroundColor: Color.fromARGB(255, 219, 34, 34),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTile(
          key: ValueKey(habit),
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text((index + 1).toString()),
          ),
          title: Text(
            habit.name,
          ),
          subtitle: Text('${habit.desc} | ${habit.duration.toString()} min'),
          trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => print("open sheet")),
        ));
  }
}
