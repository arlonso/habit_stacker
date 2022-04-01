import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'habit_stack.dart';
import 'habit_stack_list.dart';
import 'habit_stack_overview_item.dart';
import 'stack_overview_changed_callback.dart';

class HabitStackOverview extends StatefulWidget {
  const HabitStackOverview({Key? key}) : super(key: key);

  @override
  State<HabitStackOverview> createState() => _HabitStackOverviewState();
}

class _HabitStackOverviewState extends State<HabitStackOverview> {
  List<HabitStack> _habitStacks = <HabitStack>[];

  Future<void> fetchHabitStacks() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    final habitStacksJSON = prefs.getStringList('habitStacks');
    if (habitStacksJSON?.isEmpty ?? true) return;
    _habitStacks = habitStacksJSON!
        .map((habitStack) => HabitStack.fromJson(jsonDecode(habitStack)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Waiting your async function to finish
      future: fetchHabitStacks(),
      builder: (context, snapshot) {
        // Async function finished
        if (snapshot.connectionState == ConnectionState.done) {
          // To access the function data when is done
          // you can take it from **snapshot.data**
          return Scaffold(
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
          );
        } else {
          // Show loading during the async function finish to process
          return const Scaffold(body: CircularProgressIndicator());
        }
      },
    );
  }

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
