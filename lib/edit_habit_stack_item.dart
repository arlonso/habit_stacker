import 'package:flutter/material.dart';
import 'package:habit_stacker/utils/constants.dart';

import 'Habit.dart';
import 'edit_habit.dart';
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
    return Flexible(
        child: Card(
            color: COLOR_GREY,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.ac_unit_outlined,
                      size: 40,
                      color: COLOR_WHITE,
                    ),
                    const Spacer(),
                    Text(
                      habit.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ]),
            )));
    // return Slidable(
    //     // The end action pane is the one at the right or the bottom side.
    //     endActionPane: ActionPane(
    //       motion: const ScrollMotion(),
    //       children: [
    //         SlidableAction(
    //           // An action can be bigger than the others.
    //           flex: 1,
    //           onPressed: (context) =>
    //               onHabitStackChanged(habit, habit.duration, inStack, true),
    //           backgroundColor: const Color.fromARGB(255, 219, 34, 34),
    //           foregroundColor: Colors.white,
    //           icon: Icons.delete,
    //           label: 'Delete',
    //         ),
    //       ],
    //     ),
    //     child: ListTile(
    //       key: ValueKey(habit),
    //       leading: CircleAvatar(
    //         backgroundColor: Colors.blue,
    //         child: Text((index + 1).toString()),
    //       ),
    //       title: Text(
    //         habit.name,
    //       ),
    //       subtitle: Text('${habit.desc} | ${habit.duration.toString()} min'),
    //       trailing: IconButton(
    //           icon: const Icon(Icons.edit),
    //           onPressed: () => showModalBottomSheet<void>(
    //                 // radius: 25.0,
    //                 // isScrollControlled: true,
    //                 context: context,
    //                 builder: (BuildContext context) {
    //                   return NewHabit(
    //                     onHabitStackChanged,
    //                     habit: habit,
    //                   );
    //                 },
    //               )),
    //     ));
  }
}
