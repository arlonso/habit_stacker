import 'dart:ui';
import 'package:flutter/material.dart';
import 'habit_stacks_overview.dart';
import 'package:habit_stacker/utils/constants.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = window.physicalSize.width;

    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: COLOR_DARK_BLUE_SHADE_DARK,
              textTheme:
                  screenWidth < 500 ? TEXT_THEME_SMALL : TEXT_THEME_DEFAULT),
          home: const HabitStackOverview(),
        ));
  }
}
