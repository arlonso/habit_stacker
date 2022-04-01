import 'package:flutter/material.dart';

import 'habit_stack_overview.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HabitStackOverview(),
    );
  }
}
