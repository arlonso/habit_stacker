import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(const HabitStacker());
}

class Habit {
  String name;
  int duration;
  String desc;

  Habit(this.name, this.duration, [this.desc = ""]);
}

class HabitStack {
  String name;
  int duration;
  String desc;
  List<Habit> habits;

  HabitStack(this.habits, this.name, this.duration, [this.desc = ""]);
}

typedef HabitStackChangedCallback = Function(Habit habit, bool inStack);
typedef StackOverviewChangedCallback = Function(
    HabitStack habitStack, bool inOverview);

class HabitStacker extends StatelessWidget {
  const HabitStacker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HabitStackOverview(),
    );
  }
}

class AddStackButton extends StatelessWidget {
  const AddStackButton({required this.onStackOverviewChanged, Key? key})
      : super(key: key);

  final StackOverviewChangedCallback onStackOverviewChanged;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return HabitStackList(onStackOverviewChanged);
          },
        );
      },
    );
  }
}

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

  void _saveHabitStack() {
    HabitStack newHabitStack = HabitStack(
        _habitStack,
        NewHabitStackNameController.text,
        _duration,
        NewHabitStackDescController.text);
    widget.onStackOverviewChanged(newHabitStack, false);
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

class HabitStackItem extends StatelessWidget {
  HabitStackItem({
    required this.index,
    required this.habit,
    required this.inStack,
    required this.onHabitStackChanged,
  }) : super(key: ObjectKey(habit));

  final int index;
  final Habit habit;
  final bool inStack;
  final HabitStackChangedCallback onHabitStackChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text((index + 1).toString()),
      ),
      title: Text(
        habit.name,
      ),
      subtitle: Text('${habit.duration.toString()} min'),
      trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onHabitStackChanged(habit, inStack)),
    );
  }
}

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

class HabitStackOverview extends StatefulWidget {
  const HabitStackOverview({Key? key}) : super(key: key);

  @override
  State<HabitStackOverview> createState() => _HabitStackOverviewState();
}

class _HabitStackOverviewState extends State<HabitStackOverview> {
  final _habitStacks = <HabitStack>[];

  void _handleStackOverviewChanged(HabitStack habitStack, bool inOverview) {
    setState(() {
      // When a user changes what's in the stack, you need
      // to change _habitStack inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.
      print("HabitStackChanged!");
      if (!inOverview) {
        _habitStacks.add(habitStack);
      } else {
        _habitStacks.remove(habitStack);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Habit Stacker'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: _habitStacks.map((HabitStack habitStack) {
            return HabitStackOverviewItem(
              habitStack: habitStack,
              inOverview: _habitStacks.contains(habitStack),
              onStackOverviewChanged: _handleStackOverviewChanged,
            );
          }).toList(),
        ),
        floatingActionButton: AddStackButton(
          onStackOverviewChanged: _handleStackOverviewChanged,
        ),
      ),
    );
  }
}

class HabitStackOverviewItem extends StatelessWidget {
  HabitStackOverviewItem({
    required this.habitStack,
    required this.inOverview,
    required this.onStackOverviewChanged,
  }) : super(key: ObjectKey(habitStack));

  final HabitStack habitStack;
  final bool inOverview;
  final StackOverviewChangedCallback onStackOverviewChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: CircleAvatar(
      //   backgroundColor: Colors.blue,
      //   child: Text((index + 1).toString()),
      // ),
      title: Text(
        habitStack.name,
      ),
      subtitle: Text('${habitStack.duration.toString()} min'),
      trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onStackOverviewChanged(habitStack, inOverview)),
    );
  }
}
