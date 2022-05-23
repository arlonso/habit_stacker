import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_stacker/custom/custom_icons.dart';
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
  final TimeOfDay _startingTime = TimeOfDay.now();
  int _passedTimeInSeconds = 0;
  int _addedTimeInSeconds = 0;
  double _finishedHabitCount = 0;
  bool _descExpanded = false;
  late TimeOfDay _finishTime;
  late int _totalDurationInSeconds;
  late int _timerDuration;
  late Habit _activeHabit;
  late AnimationController controller;
  late final Future<LottieComposition> _composition;
  late int _durationInSeconds;

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
      _finishTime = _startingTime.plusMinutes(widget.habitStack.duration);
      _totalDurationInSeconds = widget.habitStack.duration * 60;
      _activeHabit = widget.habitStack.habits[0];
      _durationInSeconds = _activeHabit.duration * 60;
      _timerDuration = _durationInSeconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _startTimer();
      });
    });
    //initialize progress animation
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: _timerDuration))
      // upperBound: _timerDuration.toDouble())
      ..addListener(() {
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

      if (widget.habitStack.habits.length - 1 <= index) {
        _stackFinished = true;
        if (_timer != null) {
          _timer?.cancel();
          controller.stop();
          return;
        }
      }

      _calculatePassedTime();
      _calculateNewTotalTime(); // add or subtract spend time from total habit stack duration
      _calculateNewFinishTime();
      _finishedHabitCount++;
      _activeHabit = widget.habitStack.habits[index + 1];
      _durationInSeconds = _activeHabit.duration * 60;
      _timerDuration = _durationInSeconds;
      _addedTimeInSeconds = 0;
      _timeOver = false;

      //reset timer
      if (_timer != null) {
        _timer?.cancel();
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _startTimer();
      });

      controller.dispose();
      //initialize progress animation
      controller = AnimationController(
          vsync: this, duration: Duration(seconds: _timerDuration))
        // upperBound: _timerDuration.toDouble())
        ..addListener(() {
          setState(() {});
        });
      //reset animation
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

  _secondsToControllerValue(int seconds) {
    // print(
    //     "${controller.value} and ${seconds / _durationInSeconds} and $seconds}");
    return seconds / _durationInSeconds;
  }

  _calculatePassedTime() {
    setState(() {
      _passedTimeInSeconds += _timeOver
          ? _durationInSeconds + _timerDuration
          : _durationInSeconds - _timerDuration;
    });
  }

  _calculateNewTotalTime() {
    setState(() {
      if (_timeOver) {
        _totalDurationInSeconds += _timerDuration + _addedTimeInSeconds;
      } else {
        print(
            "Total duration before: ${(_totalDurationInSeconds) / 60}min, Total duration after: ${(_totalDurationInSeconds - _timerDuration + _addedTimeInSeconds) / 60}min, subtracted time: ${(-_timerDuration + _addedTimeInSeconds) / 60}min");
        _totalDurationInSeconds =
            (_totalDurationInSeconds - _timerDuration) + _addedTimeInSeconds;
      }
    });
  }

  _calculateNewFinishTime() {
    setState(() {
      int totalDurationInMinutes = (_totalDurationInSeconds / 60).round();
      _finishTime = _startingTime.plusMinutes(totalDurationInMinutes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final Size size = MediaQuery.of(context).size;
    const double padding = 20;
    final ThemeData themeData = Theme.of(context);
    return MaterialApp(
        home: Scaffold(
      backgroundColor: themeData.primaryColor,
      body: SafeArea(
          child: PageView(

              /// [PageView.scrollDirection] defaults to [Axis.horizontal].
              /// Use [Axis.vertical] to scroll vertically.
              controller: pageController,
              children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: padding, vertical: 40),
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
                                    style: const TextStyle(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, right: 10, left: 10),
                                child: Row(children: [
                                  const Icon(
                                    CustomIcons.timer_play,
                                    color: COLOR_GREY,
                                    size: 20,
                                  ),
                                  addHorizontalSpace(5),
                                  Text(
                                    _startingTime.to24hours(),
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w700,
                                        color: COLOR_GREY,
                                        fontSize: 20,
                                        height: 1.2),
                                  ),
                                ])),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, right: 10, left: 10),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        child: CircularProgressIndicator(
                                          value: _finishedHabitCount /
                                              widget.habitStack.habits.length,
                                          backgroundColor: COLOR_WHITE,
                                          color: COLOR_ACCENT,
                                          strokeWidth: 2,
                                        ),
                                        height: 45.0,
                                        width: 45.0,
                                      ),
                                      Text(
                                        "${(_finishedHabitCount).toInt()}/${widget.habitStack.habits.length}",
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w700,
                                            color: COLOR_GREY,
                                            fontSize: 16,
                                            height: 1.2),
                                      ),
                                    ])),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, right: 10, left: 10),
                                child: Row(children: [
                                  const Icon(
                                    FontAwesomeIcons.flagCheckered,
                                    color: COLOR_GREY,
                                    size: 16,
                                  ),
                                  addHorizontalSpace(10),
                                  Text(
                                    _finishTime.to24hours(),
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w700,
                                        color: COLOR_GREY,
                                        fontSize: 20,
                                        height: 1.2),
                                  ),
                                ])),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: COLOR_DARK_BLUE_SHADE_LIGHT,
                        ),
                        Visibility(
                          visible: !_descExpanded,
                          child: Column(children: [
                            addVerticalSpace(padding * 2),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: COLOR_WHITE, width: 2)),
                              child: Padding(
                                padding: const EdgeInsets.all(17),
                                child: Icon(
                                  _activeHabit.icon != null
                                      ? deserializeIcon(_activeHabit.icon!)
                                      : Icons.task,
                                  color: COLOR_WHITE,
                                  size: 52,
                                ),
                              ),
                            ),
                            addVerticalSpace(padding),
                            Text(
                              _activeHabit.name.toUpperCase(),
                              style: const TextStyle(
                                  color: COLOR_WHITE,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 45),
                              textAlign: TextAlign.center,
                            ),
                            addVerticalSpace(padding * 3),
                            Container(
                                width: size.width,
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Text(intToTimeString(_timerDuration),
                                          style: TextStyle(
                                              color: _timeOver
                                                  ? COLOR_WINE_RED_LIGHT
                                                  : COLOR_WHITE,
                                              fontWeight: FontWeight.w700,
                                              fontSize: _timerDuration >= 3600
                                                  ? 45
                                                  : 65)),
                                      !_timeOver
                                          ? Positioned(
                                              right: 20,
                                              child: InkWell(
                                                onTap: () => setState(() {
                                                  _timerDuration += 30;
                                                  _addedTimeInSeconds += 30;
                                                  _durationInSeconds += 30;
                                                  controller.reverse(
                                                      from: controller.value +
                                                          _secondsToControllerValue(
                                                              30));
                                                }),
                                                child: const Icon(
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
                            addVerticalSpace(padding),
                          ]),
                        ),
                        _activeHabit.desc.isEmpty
                            ? addVerticalSpace(padding * 4)
                            : Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    _activeHabit.desc,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                        _activeHabit.desc.isEmpty
                            ? const SizedBox.shrink()
                            : IconButton(
                                iconSize: 25,
                                color: COLOR_GREY,
                                icon: Icon(_descExpanded
                                    ? FontAwesomeIcons.circleChevronUp
                                    : FontAwesomeIcons.circleChevronDown),
                                onPressed: () => setState(() {
                                  _descExpanded = !_descExpanded;
                                }),
                              ),
                        addVerticalSpace(padding),
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
                                icon: Icon(_timePaused
                                    ? Icons.play_arrow
                                    : Icons.pause),
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
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: padding, vertical: 40),
                child: Column(children: [
                  addVerticalSpace(padding),
                  Text(
                    "Next habits:",
                    style: themeData.textTheme.headline1,
                  ),
                  const Divider(
                    thickness: 1,
                    color: COLOR_DARK_BLUE_SHADE_LIGHT,
                  ),
                  addVerticalSpace(padding),
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.habitStack.habits.length -
                            widget.habitStack.habits
                                .indexWhere((habit) => habit == _activeHabit) -
                            1,
                        itemBuilder: (BuildContext context, int index) {
                          final currentIndex = widget.habitStack.habits
                              .indexWhere((habit) => habit == _activeHabit);
                          final nextIndex = currentIndex + 1 + index;
                          if (nextIndex >= widget.habitStack.habits.length) {
                            return SizedBox.shrink();
                          }
                          print(currentIndex);
                          final nextHabit = widget.habitStack.habits[nextIndex];
                          return ListTile(
                              leading: Icon(
                                nextHabit.icon != null
                                    ? deserializeIcon(nextHabit.icon!)
                                    : Icons.task,
                                color: COLOR_GREY,
                                size: 28,
                              ),
                              trailing: Text(
                                "${nextHabit.duration}min",
                                style: TextStyle(
                                    color: COLOR_ACCENT, fontSize: 18),
                              ),
                              title: Text(
                                nextHabit.name.capitalize(),
                                style:
                                    TextStyle(color: COLOR_GREY, fontSize: 22),
                              ));
                        }),
                  )
                ]))
          ])),
    ));
  }
}
