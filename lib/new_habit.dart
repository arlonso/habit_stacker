import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'Habit.dart';
import 'habit_stack_changed_callback.dart';

class NewHabit extends StatefulWidget {
  const NewHabit(this.onHabitStackChanged, {Key? key}) : super(key: key);
  final HabitStackChangedCallback onHabitStackChanged;

  @override
  State<NewHabit> createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  final NewHabitNameController = TextEditingController();
  final NewHabitDescController = TextEditingController();
  bool _isSaveButtonDisabled = true;

  // String _HabitStackItemName = "";
  // String _HabitStackItemDesc = "";
  int _duration = 5;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    NewHabitNameController.addListener(_checkSaveButtonStatus);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    NewHabitNameController.dispose();
    NewHabitDescController.dispose();
    super.dispose();
  }

  void _checkSaveButtonStatus() {
    if (NewHabitNameController.text != "") {
      setState(() {
        _isSaveButtonDisabled = false;
      });
    } else {
      setState(() {
        _isSaveButtonDisabled = true;
      });
    }
  }

  void _saveHabit() {
    Habit newHabit = Habit(
        NewHabitNameController.text, _duration, NewHabitDescController.text);
    widget.onHabitStackChanged(newHabit, false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a stack name',
            ),
            controller: NewHabitNameController,
          ),
          Column(
            children: <Widget>[
              NumberPicker(
                value: _duration,
                minValue: 1,
                maxValue: 120,
                step: 1,
                axis: Axis.horizontal,
                onChanged: (value) => setState(() => _duration = value),
              ),
              Text('Duration: $_duration m'),
            ],
          ),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a description',
            ),
            controller: NewHabitDescController,
          ),
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
                  onPressed: () => _saveHabit()),
              SizedBox(width: 30),
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
