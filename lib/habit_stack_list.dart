import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'Habit.dart';
import 'habit_stack.dart';
import 'habit_stack_item.dart';
import 'new_habit.dart';
import 'stack_overview_changed_callback.dart';

class HabitStackList extends StatefulWidget {
  HabitStackList(this.onStackOverviewChanged, this.habitStack, {Key? key})
      : super(key: key);
  final StackOverviewChangedCallback onStackOverviewChanged;
  final HabitStack? habitStack;

  @override
  State<HabitStackList> createState() => _HabitStackListState();
}

class _HabitStackListState extends State<HabitStackList> {
  bool _isSaveButtonDisabled = true;
  bool _isInOverview = false;

  // String _HabitStackItemName = "";
  // String _HabitStackItemDesc = "";
  int _duration = 0;
  List<Habit> _habitStack = [];

  late TextEditingController newHabitStackNameController;
  late TextEditingController newHabitStackDescController;

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.habitStack != null) {
        // initialize habits
        _habitStack = widget.habitStack!.habits;
        // initialize duration
        _duration = widget.habitStack!.duration;
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
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    newHabitStackNameController.dispose();
    newHabitStackDescController.dispose();
    super.dispose();
  }

  void _handleHabitStackChanged(Habit habit, bool inStack) {
    setState(() {
      // When a user changes what's in the stack, you need
      // to change _habitStack inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.
      print("HabitStackChanged!");
      if (!inStack) {
        print("${_habitStack} für folgende habit: ${habit.name}");
        _habitStack.add(habit);
        _duration += habit.duration;
      } else {
        _habitStack.remove(habit);
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

  void _saveHabitStack() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    HabitStack finalHabitStack;

    if (_isInOverview) {
      widget.habitStack!.habits = _habitStack;
      widget.habitStack!.name = newHabitStackNameController.text;
      widget.habitStack!.desc = newHabitStackDescController.text;
      widget.habitStack!.duration = _duration;
      finalHabitStack = widget.habitStack!;
    } else {
      String name = newHabitStackNameController.text;
      String desc = newHabitStackDescController.text;
      finalHabitStack = HabitStack(_habitStack, name, _duration, desc);
    }
    //trigger callback function to update the state
    widget.onStackOverviewChanged(finalHabitStack, _isInOverview, false);

    // convert habit stack to JSON String
    String jsonHabitStack = jsonEncode(finalHabitStack);

    // save habit stack in shared preferences
    prefs.setString('habitstack-${finalHabitStack.name}', jsonHabitStack);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            // height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: newHabitStackNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a stack name',
                  ),
                ),
                TextField(
                  controller: newHabitStackDescController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a stack description',
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text('${_habitStack.length} Habits'),
                    Text('${_duration.toString()} min'),
                    Spacer(),
                    Container(
                      height: 30.0,
                      width: 30.0,
                      child: FittedBox(
                          child: FloatingActionButton(
                        child: Icon(Icons.add, size: 35),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            // radius: 25.0,
                            // isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return NewHabit(_handleHabitStackChanged);
                            },
                          );
                        },
                      )),
                    ),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: _habitStack.length,
                    itemBuilder: (BuildContext context, int index) {
                      print("index builder ${index}");
                      Habit habit = _habitStack[index];
                      return HabitStackItem(
                          index: index,
                          habit: habit,
                          inStack: _habitStack.contains(habit),
                          onHabitStackChanged: _handleHabitStackChanged);
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: _isSaveButtonDisabled
                              ? MaterialStateProperty.all(Colors.blue[100])
                              : MaterialStateProperty.all(Colors.blue),
                        ),
                        child: const Text('Save'),
                        onPressed: () => _saveHabitStack()),
                    SizedBox(width: 30),
                    ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ],
            )));
  }
}
