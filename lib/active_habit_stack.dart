import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_stacker/habit.dart';
import 'package:habit_stacker/utils/constants.dart';
import 'package:habit_stacker/utils/widget_functions.dart';
import 'package:lottie/lottie.dart';
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
  bool _timeOver = false;
  bool _stackFinished = false;
  Timer? _timer;
  double _lastControllerValue = 0;
  late int _timerDuration;
  late Habit _activeHabit;
  late AnimationController controller;
  late final Future<LottieComposition> _composition;

  void _startTimer() {
    setState(
      () {
        if (_timerDuration > 0) {
          _timerDuration--;
        } else {
          _timeOver = true;
          _timer?.cancel();
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            _continueTimer();
          });
        }
      },
    );
  }

  _continueTimer() {
    setState(
      () {
        if (_timerDuration < 7200) {
          _timerDuration++;
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

    _composition = _loadComposition();

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
        _stackFinished = true;
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

  Future<void> _playPauseTimer() async {
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

  Future<LottieComposition> _loadComposition() async {
    var assetData = await rootBundle.load('assets/celebration.json');
    return await LottieComposition.fromByteData(assetData);
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: _stackFinished
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    FutureBuilder<LottieComposition>(
                      future: _composition,
                      builder: (context, snapshot) {
                        var composition = snapshot.data;
                        if (composition != null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Routine \n finished!".toUpperCase(),
                                style: GoogleFonts.robotoCondensed(
                                  color: COLOR_WHITE,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 55,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              addVerticalSpace(padding),
                              Lottie(
                                composition: composition,
                                repeat: true,
                              )
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Positioned(
                      top: 0,
                      right: 10,
                      child: Container(
                        height: size.width * 0.13,
                        width: size.width * 0.13,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 13,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            shape: BoxShape.rectangle,
                            color: COLOR_GREY,
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.xmark,
                              color: Colors.white,
                              size: 25,
                            ),
                            onPressed: () => {Navigator.pop(context)}),
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
                    Container(
                        width: size.width,
                        child: Stack(alignment: Alignment.center, children: [
                          Text(intToTimeString(_timerDuration),
                              style: TextStyle(
                                  color: _timeOver
                                      ? COLOR_WINE_RED_LIGHT
                                      : COLOR_WHITE,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 60)),
                          // !_timeOver
                          true
                              ? Positioned(
                                  right: 20,
                                  child: InkWell(
                                    onTap: () => setState(() {
                                      _timerDuration = _timerDuration + 30;
                                      controller.reverse(
                                          from: controller.value + 30);
                                    }),
                                    child: Icon(
                                      Icons.replay_30,
                                      size: 40,
                                      color: COLOR_GREY,
                                    ),
                                  ))
                              : const SizedBox.shrink(),
                        ])),
                    _timeOver
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                                "Usual habit duration: ${_activeHabit.duration}min",
                                style: const TextStyle(
                                    color: COLOR_WHITE,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18)))
                        : const SizedBox.shrink(),
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
