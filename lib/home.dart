import 'package:flutter/material.dart';

import 'habit_stacks_overview.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HabitStackOverview(),
    );
  }
}
