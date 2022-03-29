import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(const HabitStacker());
}

class Habit {
  const Habit({required this.name});

  final String name;
}

typedef HabitStackChangedCallback = Function(Habit habit, bool inStack);

class HabitStacker extends StatelessWidget {
  const HabitStacker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Stacker',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Welcome to Flutter'),
          ),
          body: const Center(
            child: Text('Hello World'),
          ),
          floatingActionButton: AddStackButton()),
    );
  }
}

class AddStackButton extends StatelessWidget {
  const AddStackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return HabitStack();
          },
        );
      },
    );
  }
}

class HabitStack extends StatefulWidget {
  const HabitStack({required this.habits, Key? key}) : super(key: key);
  final List<Habit> habits;

  @override
  State<HabitStack> createState() => _HabitStackState();
}

class _HabitStackState extends State<HabitStack> {
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
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a stack name',
            ),
          ),
          Row(
            children: <Widget>[
              Text('0 Habits'),
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
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return const HabitStackItem();
                      },
                    );
                  },
                )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () => Navigator.pop(context),
              ),
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

class HabitStackItem extends StatefulWidget {
  const HabitStackItem({Key? key}) : super(key: key);

  @override
  State<HabitStackItem> createState() => _HabitStackItemState();
}

class _HabitStackItemState extends State<HabitStackItem> {
  final HabitStackItemNameController = TextEditingController();
  final HabitStackItemDescController = TextEditingController();
  bool _isSaveButtonDisabled = true;
  // String _HabitStackItemName = "";
  // String _HabitStackItemDesc = "";
  int _currentValue = 5;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    HabitStackItemNameController.addListener(_checkSaveButtonStatus);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    HabitStackItemNameController.dispose();
    HabitStackItemDescController.dispose();
    super.dispose();
  }

  void _checkSaveButtonStatus() {
    if (HabitStackItemNameController.text != "") {
      setState(() {
        _isSaveButtonDisabled = false;
      });
    } else {
      setState(() {
        _isSaveButtonDisabled = true;
      });
    }
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
            controller: HabitStackItemNameController,
            onChanged: (text) {
              print('First text field: $text');
            },
          ),
          Column(
            children: <Widget>[
              NumberPicker(
                value: _currentValue,
                minValue: 1,
                maxValue: 120,
                step: 1,
                axis: Axis.horizontal,
                onChanged: (value) => setState(() => _currentValue = value),
              ),
              Text('Duration: $_currentValue m'),
            ],
          ),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a description',
            ),
            controller: HabitStackItemDescController,
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
                onPressed: () => Navigator.pop(context),
              ),
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

//LIST VIEW
class HabitStacks extends StatelessWidget {
  const HabitStacks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}
