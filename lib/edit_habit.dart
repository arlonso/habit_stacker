import 'package:flutter/material.dart';
import 'package:habit_stacker/habit.dart';
import 'package:habit_stacker/utils/constants.dart';
import 'package:habit_stacker/utils/widget_functions.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
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
  Icon? _icon;

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
        _icon = Icon(
          IconData(widget.habit!.iconCode!,
              fontFamily: widget.habit!.fontFamily),
          color: COLOR_WHITE,
          size: 52,
        );
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

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [
          IconPack.fontAwesomeIcons,
          IconPack.lineAwesomeIcons,
          IconPack.material
        ]);

    _icon = Icon(
      icon ?? Icons.task,
      color: COLOR_WHITE,
      size: 52,
    );
    setState(() {});

    debugPrint('Picked Icon:  ${icon.toString()}');
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
      widget.habit!.iconCode = _icon!.icon!.codePoint;
      finalHabit = widget.habit!;
    } else {
      finalHabit = Habit(
        newHabitNameController.text,
        _duration,
        newHabitDescController.text,
      );

      if (_icon != null) {
        finalHabit.iconCode = _icon!.icon!.codePoint;
        finalHabit.fontFamily = _icon!.icon!.fontFamily;
      }
    }
    widget.onHabitStackChanged(finalHabit, _oldDuration, _inStack, false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    const double padding = 25;
    return SafeArea(
        child: Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
              onTap: _pickIcon,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: COLOR_WHITE, width: 2)),
                child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _icon ??
                          const Icon(
                            Icons.task,
                            color: COLOR_WHITE,
                            size: 52,
                          ),
                    )),
              )),
          addVerticalSpace(padding),
          TextField(
            textAlign: TextAlign.center,
            controller: newHabitNameController,
            style: themeData.textTheme.headline2,
            decoration: const InputDecoration(
              suffixIcon: Icon(
                Icons.edit,
                color: COLOR_GREY,
              ),
              hintStyle: TextStyle(color: COLOR_GREY),
              border: InputBorder.none,
              hintText: 'Enter a stack name',
            ),
          ),
          addVerticalSpace(padding),
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
          addVerticalSpace(padding),
          TextField(
            textAlign: TextAlign.center,
            controller: newHabitDescController,
            style: themeData.textTheme.headline4,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              suffixIcon: Icon(
                Icons.edit,
                color: COLOR_GREY,
              ),
              hintStyle: TextStyle(color: COLOR_GREY),
              border: InputBorder.none,
              hintText: 'Enter a description',
            ),
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
