import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: index == 0
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Container(
              //   height: 392,
              //   decoration: const BoxDecoration(
              //     borderRadius: BorderRadius.only(
              //       bottomLeft: Radius.circular(22),
              //       bottomRight: Radius.circular(22),
              //     ),
              //     gradient: LinearGradient(
              //       begin: Alignment.topLeft,
              //       end: Alignment(1, 0.0),
              //       colors: <Color>[
              //         Color(0xFFF4C465),
              //         Color(0xFFC63956),
              //       ],
              //     ),
              //     image: DecorationImage(
              //       alignment: Alignment.topCenter,
              //       image: AssetImage('assets/images/morning.jpg'),
              //     ),
              //   ),
              // ),
              Padding(
                  padding: const EdgeInsets.only(top: padding, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Column(
                      children: [
                        Stack(alignment: Alignment.center, children: [
                          Image(
                            height: 175,
                            image: AssetImage("assets/images/morning.jpg"),
                            fit: BoxFit.cover,
                            color: Colors.white.withOpacity(0.7),
                            colorBlendMode: BlendMode.modulate,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Container(
                              height: size.width * 0.14,
                              width: size.width * 0.14,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    spreadRadius: 0,
                                    blurRadius: 13,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                shape: BoxShape.circle,
                                color: COLOR_ACCENT,
                              ),
                              child: IconButton(
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ActiveHabitStack(
                                                        habitStack: habitStack))
                                            // onPressed: () => onStackOverviewChanged(habitStack, inOverview)),
                                            ),
                                      }),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                                height: size.width * 0.1,
                                // width: size.width * 0.1,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: COLOR_DARK_BLUE,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "12:00",
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w700,
                                        color: COLOR_GREY,
                                        fontSize: 24,
                                        height: 1.2),
                                  ),
                                )),
                          )
                        ]),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  COLOR_DARK_BLUE_SHADE_DARK,
                                  COLOR_DARK_BLUE_SHADE_LIGHT
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(habitStack.name,
                                        style: themeData.textTheme.headline1),
                                    addHorizontalSpace(10),
                                    Text(
                                      "${habitStack.duration.toString()} min | ${habitStack.habits.length == 1 ? "${habitStack.habits.length} habit" : "${habitStack.habits.length} habits"}",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w300,
                                        color: const Color(0xFF8C8C8C),
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ])),
                        )
                      ],
                    ),
                  ))
            ])
          : Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                height: 134,
                child: Stack(alignment: Alignment.bottomLeft, children: [
                  Container(
                    height: 92,
                    width: size.width - (size.width * 0.16),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 13,
                            offset: const Offset(0, 4),
                          )
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: COLOR_DARK_BLUE_SHADE_LIGHT),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 14,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    "assets/images/mid-day.jpg",
                                  ),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                habitStack.name,
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Row(children: [
                                Icon(
                                  Icons.timer_sharp,
                                  color: COLOR_GREY,
                                  size: 16,
                                ),
                                addHorizontalSpace(5),
                                Text(
                                  "${habitStack.duration.toString()} min | ${habitStack.habits.length} habits",
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF8C8C8C),
                                    fontSize: 12,
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: COLOR_GREY,
                                  size: 16,
                                ),
                                addHorizontalSpace(5),
                                Text(
                                  "12:00 am",
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF8C8C8C),
                                    fontSize: 12,
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 27,
                    right: 0,
                    child: Container(
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: COLOR_ACCENT,
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white),
                    ),
                  )
                ]),
              )),
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
