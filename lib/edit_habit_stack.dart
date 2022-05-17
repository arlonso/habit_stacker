import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_stacker/active_habit_stack.dart';
import 'package:habit_stacker/habit.dart';
import 'package:habit_stacker/utils/constants.dart';
import 'package:habit_stacker/utils/widget_functions.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'habit_stack.dart';
import 'edit_habit_stack_item.dart';
import 'edit_habit.dart';
import 'stack_overview_changed_callback.dart';

class HabitStackList extends StatefulWidget {
  const HabitStackList(this.onStackOverviewChanged, this.habitStack, {Key? key})
      : super(key: key);
  final StackOverviewChangedCallback onStackOverviewChanged;
  final HabitStack? habitStack;

  @override
  State<HabitStackList> createState() => _HabitStackListState();
}

class _HabitStackListState extends State<HabitStackList> {
  final ScrollController _scrollController = ScrollController();
  bool _isSaveButtonDisabled = true;
  bool _isInOverview = false;

  // String _HabitStackItemName = "";
  // String _HabitStackItemDesc = "";
  int _duration = 0;
  List<Habit> _habitStack = [];
  List<int> _habitStackTime = [];
  TimeOfDay _selectedTime = TimeOfDay.now();

  late TextEditingController newHabitStackNameController;
  late TextEditingController newHabitStackDescController;

  @override
  void initState() {
    setState(() {
      if (widget.habitStack != null) {
        // initialize habits
        _habitStack = widget.habitStack!.habits;
        // initialize duration
        _duration = widget.habitStack!.duration;
        //initialize time
        _selectedTime = TimeOfDay(
            hour: widget.habitStack!.time[0],
            minute: widget.habitStack!.time[1]);
        _habitStackTime = widget.habitStack!.time;
        newHabitStackNameController =
            TextEditingController(text: widget.habitStack!.name);
        newHabitStackDescController = newHabitStackDescController =
            TextEditingController(text: widget.habitStack!.desc);
        _isSaveButtonDisabled = false;
        _isInOverview = true;
      } else {
        newHabitStackNameController = TextEditingController();
        newHabitStackDescController =
            newHabitStackDescController = TextEditingController();
      }
      // Start listening to changes.
      newHabitStackNameController.addListener(_checkSaveButtonStatus);
    });

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    newHabitStackNameController.dispose();
    newHabitStackDescController.dispose();
    super.dispose();
  }

  void _handleHabitStackChanged(
      Habit habit, int oldDuration, bool inStack, bool toBeDeleted) {
    setState(() {
      // When a user changes what's in the stack, you need
      // to change _habitStack inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.
      print("HabitStackChanged!");
      if (!inStack) {
        // print("${_habitStack} für folgende habit: ${habit.name}");
        _habitStack.add(habit);
        _duration += habit.duration;
      } else if (toBeDeleted) {
        _habitStack.remove(habit);
        _duration -= habit.duration;
      } else if (oldDuration != habit.duration) {
        int difference = habit.duration - oldDuration;
        _duration += difference;
      }
    });
  }

  void _checkSaveButtonStatus() {
    if (newHabitStackNameController.text == "" || _habitStack.isEmpty) {
      setState(() {
        _isSaveButtonDisabled = true;
      });
    } else {
      setState(() {
        _isSaveButtonDisabled = false;
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTime) {
      setState(() {
        _selectedTime = timeOfDay;
      });
    }
  }

  void _saveHabitStack() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    HabitStack finalHabitStack;

    if (_isInOverview) {
      widget.habitStack!.habits = _habitStack;
      widget.habitStack!.name = newHabitStackNameController.text;
      widget.habitStack!.desc = newHabitStackDescController.text;
      widget.habitStack!.duration = _duration;
      widget.habitStack!.time = [_selectedTime.hour, _selectedTime.minute];
      finalHabitStack = widget.habitStack!;
    } else {
      String name = newHabitStackNameController.text;
      String desc = newHabitStackDescController.text;
      finalHabitStack = HabitStack(_habitStack, name, _duration,
          [_selectedTime.hour, _selectedTime.minute], desc);
    }
    //trigger callback function to update the state
    widget.onStackOverviewChanged(finalHabitStack, _isInOverview, false);

    // convert habit stack to JSON String
    String jsonHabitStack = jsonEncode(finalHabitStack);

    // save habit stack in shared preferences
    prefs.setString('habitstack-${finalHabitStack.name}', jsonHabitStack);

    Navigator.pop(context);
  }

  void _updateHabitStackListOrder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex = newIndex - 1;
      }
      final element = _habitStack.removeAt(oldIndex);
      _habitStack.insert(newIndex, element);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    const double padding = 25;
    return Stack(alignment: Alignment.topCenter, children: [
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: [
                const Image(
                  height: 200,
                  image: AssetImage("assets/images/midday.jpg"),
                  fit: BoxFit.cover,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: padding, vertical: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
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
                                  Icons.arrow_back_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                onPressed: () => {Navigator.pop(context)}),
                          ),
                          widget.habitStack != null
                              ? Container(
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
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      onPressed: () => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActiveHabitStack(
                                                            habitStack: widget
                                                                .habitStack!))
                                                // onPressed: () => onStackOverviewChanged(habitStack, inOverview)),
                                                ),
                                          }),
                                )
                              : const SizedBox.shrink()
                        ])),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [
                Expanded(
                    child: TextField(
                  controller: newHabitStackNameController,
                  style: themeData.textTheme.headline2,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: COLOR_GREY),
                    border: InputBorder.none,
                    hintText: 'Enter a stack name',
                  ),
                )),
                Container(
                  height: size.width * 0.1,
                  // width: size.width * 0.1,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: COLOR_DARK_BLUE,
                  ),
                  child: InkWell(
                      onTap: () => _selectTime(context),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "${_selectedTime.hour}:${_selectedTime.minute < 10 ? "0" + _selectedTime.minute.toString() : _selectedTime.minute}",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              color: COLOR_GREY,
                              fontSize: 24,
                              height: 1.2),
                        ),
                      )),
                ),
              ]),
            ),
            const Divider(
              height: 5,
              color: COLOR_GREY,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: newHabitStackDescController,
                  style: themeData.textTheme.headline4,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: COLOR_GREY),
                    border: InputBorder.none,
                    hintText: 'Enter a stack description',
                  ),
                )),
            const Divider(
              height: 5,
              color: COLOR_GREY,
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 8),
              child: Text(
                '${_habitStack.length} Habits | ${_duration.toString()} min',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  color: COLOR_GREY,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ReorderableGridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 4,
                  children: _habitStack
                      .mapIndexed<Widget>((i, habit) => HabitStackItem(
                          index: i,
                          habit: habit,
                          inStack: _habitStack.contains(habit),
                          onHabitStackChanged: _handleHabitStackChanged))
                      .toList(),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      _updateHabitStackListOrder(oldIndex, newIndex);
                    });
                  },
                  footer: [
                    Card(
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet<void>(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  topLeft: Radius.circular(25)),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                  heightFactor: 0.8,
                                  child: NewHabit(_handleHabitStackChanged));
                            },
                          );
                        },
                        child: Container(
                          child: Center(child: Icon(Icons.add)),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
      Positioned(
        bottom: 10,
        child: ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: padding)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
              backgroundColor: _isSaveButtonDisabled
                  ? MaterialStateProperty.all(Colors.blue[100])
                  : MaterialStateProperty.all(Colors.blue),
            ),
            child: const Text('Save'),
            onPressed: () => _saveHabitStack()),
      )
    ]);
  }
}
