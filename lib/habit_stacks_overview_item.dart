import 'package:flutter/material.dart';
import 'package:habit_stacker/active_habit_stack.dart';
import 'package:habit_stacker/edit_habit_stack.dart';
import 'package:habit_stacker/utils/constants.dart';
import 'package:habit_stacker/utils/widget_functions.dart';

import 'custom/border_icon.dart';
import 'habit_stack.dart';
import 'stack_overview_changed_callback.dart';

class HabitStackOverviewItem extends StatelessWidget {
  HabitStackOverviewItem({
    required this.index,
    required this.habitStack,
    required this.inOverview,
    required this.onStackOverviewChanged,
  }) : super(key: ObjectKey(habitStack));

  final int index;
  final HabitStack habitStack;
  final bool inOverview;
  final StackOverviewChangedCallback onStackOverviewChanged;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    const double padding = 25;
    const sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: index == 0
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image.asset(
                        "assets/images/nature.jpg",
                        color: Colors.white.withOpacity(0.8),
                        colorBlendMode: BlendMode.modulate,
                      )),
                  Column(children: [
                    BorderIcon(
                        child: Icon(
                      Icons.play_arrow,
                      color: COLOR_GREY.withOpacity(0.4),
                      size: 40,
                    )),
                    addVerticalSpace(25),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [COLOR_WHITE, COLOR_GREY],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(children: [
                            Text(
                              habitStack.name,
                              style: themeData.textTheme.headline1,
                            ),
                            addVerticalSpace(10),
                            Text(
                              "${habitStack.duration.toString()} min | ${habitStack.habits.length == 1 ? "${habitStack.habits.length} habit" : "${habitStack.habits.length} habits"}",
                              style: themeData.textTheme.headline5,
                            )
                          ])),
                    )
                  ])
                ],
              ),
            ])
          : Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 134,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      height: 92,
                      width: size.width - (size.width * 0.03),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: COLOR_DARK_BLUE_SHADE_LIGHT),
                    )
                  ],
                ),
              ),
            ),
    );
    // return ListTile(
    //   // leading: CircleAvatar(
    //   //   backgroundColor: Colors.blue,
    //   //   child: Text((index + 1).toString()),
    //   // ),
    //   title: Text(
    //     habitStack.name,
    //   ),
    //   subtitle: Text(
    //       '${habitStack.desc != "" ? "${habitStack.desc} | " : ""}${habitStack.duration.toString()} min'),
    //   leading: IconButton(
    //       icon: const Icon(Icons.play_circle_outline),
    //       onPressed: () => {
    //             Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (context) =>
    //                         ActiveHabitStack(habitStack: habitStack))
    //                 // onPressed: () => onStackOverviewChanged(habitStack, inOverview)),
    //                 ),
    //           }),
    //   trailing: IconButton(
    //       icon: const Icon(Icons.edit),
    //       onPressed: () => {
    //             showModalBottomSheet<void>(
    //               isScrollControlled: true,
    //               context: context,
    //               builder: (BuildContext context) {
    //                 return HabitStackList(onStackOverviewChanged, habitStack);
    //               },
    //             ),
    //           }),
    // );
  }
}
