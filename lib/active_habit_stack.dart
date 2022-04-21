import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_stacker/utils/constants.dart';
import 'package:habit_stacker/utils/widget_functions.dart';
import 'package:lottie/lottie.dart';
import 'package:habit_stacker/Habit.dart';
import 'package:habit_stacker/utils/custom_functions.dart';
import 'package:habit_stacker/habit_stack.dart';

class ActiveHabitStack extends StatefulWidget {
  const ActiveHabitStack({required this.habitStack, Key? key})
      : super(key: key);

  final HabitStack habitStack;

  @override
  State<ActiveHabitStack> createState() => _ActiveHabitStackState();
}

class _ActiveHabitStackState extends State<ActiveHabitStack>
    with TickerProviderStateMixin {
  // final HabitStack _habitStack = HabitStack([
  //   Habit("iss was", 4, "what is you doin??"),
  //   Habit("trink was", 8),
  //   Habit("sitz was", 10)
  // ], "Top of the morning", 22);

  bool _timePaused = false;
  bool _routineFinished = false;
  Timer? _timer;
  double _lastControllerValue = 0;
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
      _activeHabit = widget.habitStack.habits[0];
      final durationInSeconds = _activeHabit.duration * 60;
      _timerDuration = durationInSeconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _startTimer();
      });
    });
    //initialize progress animation
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: _timerDuration))
      // upperBound: _timerDuration.toDouble())
      ..addListener(() {
        print(controller.value);
        setState(() {});
      });
    controller.reverse(from: (_timerDuration.toDouble()));

    //initialize timer
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _moveToNextHabit() {
    setState(() {
      final index = widget.habitStack.habits.indexOf(_activeHabit);

      if (widget.habitStack.habits.length - 1 > index) {
        _activeHabit = widget.habitStack.habits[index + 1];
      } else {
        _routineFinished = true;
        if (_timer != null) {
          _timer?.cancel();
          controller.stop();
          return;
        }
      }

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
      _timePaused = true;
      _timer?.cancel();
      _timer = null;

      // save controller value
      setState(() {
        _lastControllerValue = controller.value;
      });
      // stop animation
      controller.stop(canceled: false);
    } else {
      _timePaused = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _startTimer();
      });
      print(_timerDuration);
      //continue animation
      controller.reverse(from: _lastControllerValue);
      // controller.value = _timerDuration.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const double padding = 20;
    final ThemeData themeData = Theme.of(context);
    return MaterialApp(
        home: Scaffold(
      backgroundColor: themeData.primaryColor,
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: _routineFinished
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.habitStack.name} \n finished!"
                              .toUpperCase(),
                          style: const TextStyle(
                              color: COLOR_WHITE,
                              fontWeight: FontWeight.w700,
                              fontSize: 40,
                              height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        addVerticalSpace(padding),
                        Lottie.asset(
                          'assets/celebration.json',
                          repeat: true,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 32,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _activeHabit.name.toUpperCase(),
                      style: const TextStyle(
                          color: COLOR_WHITE,
                          fontWeight: FontWeight.w500,
                          fontSize: 40),
                    ),
                    addVerticalSpace(padding),
                    Text(
                      _activeHabit.desc,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(intToTimeLeft(_timerDuration),
                        style: const TextStyle(
                            color: COLOR_WHITE,
                            fontWeight: FontWeight.w700,
                            fontSize: 60)),
                    addVerticalSpace(padding * 2),
                    LinearProgressIndicator(
                      color: COLOR_GREY,
                      backgroundColor: COLOR_DARK_BLUE_SHADE_LIGHT,
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                    addVerticalSpace(padding * 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: COLOR_ACCENT,
                          child: IconButton(
                            iconSize: 30,
                            color: Colors.white,
                            icon: const Icon(Icons.exit_to_app),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: COLOR_ACCENT,
                          child: IconButton(
                            iconSize: 30,
                            color: Colors.white,
                            icon: Icon(
                                _timePaused ? Icons.play_arrow : Icons.pause),
                            onPressed: () => _playPauseTimer(),
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: COLOR_ACCENT,
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
