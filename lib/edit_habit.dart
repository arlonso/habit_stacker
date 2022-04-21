import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'Habit.dart';
import 'habit_stack_changed_callback.dart';

class NewHabit extends StatefulWidget {
  const NewHabit(this.onHabitStackChanged, {this.habit, Key? key})
      : super(key: key);
  final HabitStackChangedCallback onHabitStackChanged;
  final Habit? habit;

  @override
  State<NewHabit> createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  late TextEditingController newHabitNameController;
  late TextEditingController newHabitDescController;
  bool _isSaveButtonDisabled = true;
  bool _inStack = false;

  // String _HabitStackItemName = "";
  // String _HabitStackItemDesc = "";
  int _duration = 5;
  int _oldDuration = 0;

  @override
  void initState() {
    setState(() {
      if (widget.habit != null) {
        // initialize habit name, desc and duration
        newHabitNameController =
            TextEditingController(text: widget.habit!.name);
        newHabitDescController =
            TextEditingController(text: widget.habit!.desc);
        _duration = widget.habit!.duration;
        _oldDuration = widget.habit!.duration;
        _isSaveButtonDisabled = false;
        _inStack = true;
      } else {
        newHabitNameController = TextEditingController();
        newHabitDescController = TextEditingController();
      }
    });
    // Start listening to changes.
    newHabitNameController.addListener(_checkSaveButtonStatus);

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    newHabitNameController.dispose();
    newHabitDescController.dispose();
    super.dispose();
  }

  void _checkSaveButtonStatus() {
    if (newHabitNameController.text != "") {
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
    final Habit finalHabit;
    if (_inStack) {
      widget.habit!.name = newHabitNameController.text;
      widget.habit!.duration = _duration;
      widget.habit!.desc = newHabitDescController.text;
      finalHabit = widget.habit!;
    } else {
      finalHabit = Habit(
          newHabitNameController.text, _duration, newHabitDescController.text);
    }
    widget.onHabitStackChanged(finalHabit, _oldDuration, _inStack, false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter a stack name',
            ),
            controller: newHabitNameController,
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
            decoration: const InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter a description',
            ),
            controller: newHabitDescController,
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
              const SizedBox(width: 30),
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
