import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Habit.dart';
import 'habit_stack.dart';
import 'habit_stack_item.dart';
import 'new_habit.dart';
import 'stack_overview_changed_callback.dart';

class HabitStackList extends StatefulWidget {
  HabitStackList(this.onStackOverviewChanged, {Key? key}) : super(key: key);
  final StackOverviewChangedCallback onStackOverviewChanged;

  @override
  State<HabitStackList> createState() => _HabitStackListState();
}

class _HabitStackListState extends State<HabitStackList> {
  final _habitStack = <Habit>[];

  final NewHabitStackNameController = TextEditingController();
  final NewHabitStackDescController = TextEditingController();
  bool _isSaveButtonDisabled = true;

  // String _HabitStackItemName = "";
  // String _HabitStackItemDesc = "";
  int _duration = 0;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    NewHabitStackNameController.addListener(_checkSaveButtonStatus);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    NewHabitStackNameController.dispose();
    NewHabitStackDescController.dispose();
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
    if (NewHabitStackNameController.text != "") {
      setState(() {
        _isSaveButtonDisabled = false;
      });
    } else {
      setState(() {
        _isSaveButtonDisabled = true;
      });
    }
  }

  void _saveHabitStack() async {
    String name = NewHabitStackNameController.text;
    String desc = NewHabitStackDescController.text;
    HabitStack newHabitStack = HabitStack(_habitStack, name, _duration, desc);
    widget.onStackOverviewChanged(newHabitStack, false);
    // convert habit stack to JSON String
    String jsonHabitStack = jsonEncode(newHabitStack);
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // check if string list was already created
    if (prefs.getStringList('habitStacks') != null) {
      final habitStacks = prefs.getStringList('habitStacks');
      habitStacks?.add(jsonHabitStack);
      prefs.setStringList('habitStacks', habitStacks!);
    } else {
      prefs.setStringList('habitStacks', [jsonHabitStack]);
    }

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
                  controller: NewHabitStackNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a stack name',
                  ),
                ),
                TextField(
                  controller: NewHabitStackDescController,
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
