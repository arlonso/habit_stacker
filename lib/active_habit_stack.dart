import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_stacker/Habit.dart';
import 'habit_stack.dart';

class ActiveHabitStack extends StatefulWidget {
  const ActiveHabitStack({Key? key}) : super(key: key);

  @override
  State<ActiveHabitStack> createState() => _ActiveHabitStackState();
}

class _ActiveHabitStackState extends State<ActiveHabitStack>
    with TickerProviderStateMixin {
  final HabitStack _habitStack = HabitStack([
    Habit("iss was", 4, "what is you doin??"),
    Habit("trink was", 8),
    Habit("sitz was", 10)
  ], "Top of the morning", 22);
  Timer? _timer;
  late int _timerDuration;
  late Habit _activeHabit;
  late AnimationController controller;

  void _startTimer() {
    setState(
      () {
        if (_timerDuration > 0) {
          _timerDuration--;
        } else {
          _timer?.cancel();
        }
      },
    );
  }

  @override
  void initState() {
    //initialize active habit
    setState(() {
      _activeHabit = _habitStack.habits[0];
      final durationInSeconds = _activeHabit.duration * 60;
      _timerDuration = durationInSeconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _startTimer();
      });
    });
    //initialize progress animation
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: _timerDuration))
      ..addListener(() {
        setState(() {});
      });
    controller.reverse(from: _timerDuration.toDouble());
    //initialize timer
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    controller.dispose();
  }

  String _intToTimeLeft(int value) {
    int m, s;

    m = value ~/ 60;

    s = value - (m * 60);

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();

    String result = "$minuteLeft:$secondsLeft";

    return result;
  }

  void _moveToNextHabit() {
    setState(() {
      final index = _habitStack.habits.indexOf(_activeHabit);
      _activeHabit = _habitStack.habits[index + 1];
      final durationInSeconds = _activeHabit.duration * 60;
      _timerDuration = durationInSeconds;
      //reset timer
      if (_timer != null) {
        _timer?.cancel();
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _startTimer();
      });

      //reset animation
      controller.reset();
      controller.reverse(from: _timerDuration.toDouble());
    });
  }

  void _playPauseTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      // stop animation
      controller.stop(canceled: false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _startTimer();
      });
      print(_timerDuration);
      //continue animation
      controller.reverse(from: _activeHabit.duration.toDouble());
      controller.value = _timerDuration.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Habit Stacker'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _activeHabit.name.toUpperCase(),
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                _activeHabit.desc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                _intToTimeLeft(_timerDuration),
                style: Theme.of(context).textTheme.headline2,
              ),
              LinearProgressIndicator(
                value: controller.value,
                semanticsLabel: 'Linear progress indicator',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromARGB(255, 142, 132, 231),
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.white,
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () => print("TEST"),
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromARGB(255, 142, 132, 231),
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.white,
                      icon: const Icon(Icons.pause),
                      onPressed: () => _playPauseTimer(),
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromARGB(255, 142, 132, 231),
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.white,
                      icon: const Icon(Icons.check),
                      onPressed: () => _moveToNextHabit(),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
