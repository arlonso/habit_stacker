import 'package:flutter/material.dart';

import 'habit_stack.dart';
import 'stack_overview_changed_callback.dart';

class HabitStackOverviewItem extends StatelessWidget {
  HabitStackOverviewItem({
    required this.habitStack,
    required this.inOverview,
    required this.onStackOverviewChanged,
  }) : super(key: ObjectKey(habitStack));

  final HabitStack habitStack;
  final bool inOverview;
  final StackOverviewChangedCallback onStackOverviewChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: CircleAvatar(
      //   backgroundColor: Colors.blue,
      //   child: Text((index + 1).toString()),
      // ),
      title: Text(
        habitStack.name,
      ),
      subtitle: Text('${habitStack.duration.toString()} min'),
      trailing: IconButton(
          icon: const Icon(Icons.play_circle_outline),
          // onPressed: () => Navigator.popAndPushNamed(context, routeName)),
          // icon: const Icon(Icons.delete),
          onPressed: () => onStackOverviewChanged(habitStack, inOverview)),
    );
  }
}
