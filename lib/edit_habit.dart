import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_stacker/habit.dart';
import 'package:habit_stacker/utils/constants.dart';
import 'package:habit_stacker/utils/widget_functions.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'habit_stack_changed_callback.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          widget.habit!.icon != null
              ? deserializeIcon(widget.habit!.icon!)
              : Icons.task,
          color: COLOR_WHITE,
          size: 45,
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

    debugPrint(
        'Picked Icon:  ${icon.toString()}, ${icon?.codePoint.toRadixString(16)}');
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
        newHabitNameController.text,
        _duration,
        newHabitDescController.text,
      );
    }
    if (_icon != null) {
      finalHabit.icon = serializeIcon(_icon!.icon!);
    }
    widget.onHabitStackChanged(finalHabit, _oldDuration, _inStack, false);
    Navigator.pop(context);
  }

  void _deleteHabit() {
    widget.onHabitStackChanged(
        widget.habit!, widget.habit!.duration, _inStack, true);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    const double padding = 25;
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                    child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 50, left: 20, right: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                            onTap: _pickIcon,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: COLOR_WHITE, width: 2)),
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
                              onChanged: (value) =>
                                  setState(() => _duration = value),
                            ),
                            Text('Duration: $_duration m'),
                          ],
                        ),
                        addVerticalSpace(padding),
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical, //.horizontal
                            child: TextField(
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
                          ),
                        ),
                        addVerticalSpace(10),
                        ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(horizontal: padding)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              backgroundColor: _isSaveButtonDisabled
                                  ? MaterialStateProperty.all(Colors.blue[100])
                                  : MaterialStateProperty.all(Colors.blue),
                            ),
                            child: Text(
                              'Save',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                color: COLOR_WHITE,
                                fontSize: 17,
                              ),
                            ),
                            onPressed: () => _saveHabit()),
                        InkWell(
                            child: Text(
                              widget.habit != null ? 'Delete' : 'Cancel',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                color: COLOR_GREY,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () => widget.habit != null
                                ? _deleteHabit()
                                : Navigator.pop(context)),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   top: 20,
                  //   left: 20,
                  //   child: Container(
                  //     height: size.width * 0.13,
                  //     width: size.width * 0.13,
                  //     decoration: BoxDecoration(
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.black.withOpacity(0.3),
                  //             spreadRadius: 0,
                  //             blurRadius: 13,
                  //             offset: const Offset(0, 4),
                  //           ),
                  //         ],
                  //         shape: BoxShape.rectangle,
                  //         color: COLOR_GREY,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: IconButton(
                  //         icon: const Icon(
                  //           Icons.arrow_back_outlined,
                  //           color: Colors.white,
                  //           size: 25,
                  //         ),
                  //         onPressed: () => {_saveHabit()}),
                  //   ),
                  // )
                )))));
  }
}
