import 'dart:convert';

import 'package:habit_stacker/custom/border_icon.dart';
import 'package:habit_stacker/utils/constants.dart';
import 'package:habit_stacker/utils/widget_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'habit_stack.dart';
import 'edit_habit_stack.dart';
import 'habit_stacks_overview_item.dart';
import 'stack_overview_changed_callback.dart';

class HabitStackOverview extends StatefulWidget {
  const HabitStackOverview({Key? key}) : super(key: key);

  @override
  State<HabitStackOverview> createState() => _HabitStackOverviewState();
}

class _HabitStackOverviewState extends State<HabitStackOverview> {
  final List<HabitStack> _habitStacks = <HabitStack>[];
  late Future future;

  @override
  void initState() {
    future = fetchHabitStacks();
    super.initState();
  }

  Future<void> fetchHabitStacks() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    if (keys.isEmpty) return;
    for (var key in keys) {
      if (key.contains('habitstack-')) {
        HabitStack stack =
            HabitStack.fromJson(jsonDecode(prefs.getString(key)!));
        _habitStacks.add(stack);
      }
    }
    print("habit Stacks: $_habitStacks");
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    const double padding = 25;
    const sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return FutureBuilder(
      // Waiting your async function to finish
      future: future,
      builder: (context, snapshot) {
        // Async function finished
        if (snapshot.connectionState == ConnectionState.done) {
          // To access the function data when is done
          // you can take it from **snapshot.data**
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: SafeArea(
              child: Container(
                width: size.width,
                height: size.height,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(padding),
                      Padding(
                        padding: sidePadding,
                        child: Text(
                          "Hello it's time for:",
                          style: themeData.textTheme.headline1,
                        ),
                      ),
                      addVerticalSpace(padding),
                      const Padding(
                        padding: sidePadding,
                        child: Divider(
                          height: 1,
                          color: COLOR_GREY,
                        ),
                      ),
                      // addVerticalSpace(10),
                      Expanded(
                        child: Padding(
                          padding: sidePadding,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: _habitStacks.length,
                            // scrollDirection: Axis.vertical,
                            // shrinkWrap: true,
                            itemBuilder: (context, index) {
                              HabitStack habitStack = _habitStacks[index];
                              return HabitStackOverviewItem(
                                index: index,
                                habitStack: habitStack,
                                inOverview: _habitStacks.contains(habitStack),
                                onStackOverviewChanged:
                                    _handleStackOverviewChanged,
                              );
                            },
                          ),
                        ),
                      )
                    ]),
              ),
            ),
            floatingActionButton: AddStackButton(
              onStackOverviewChanged: _handleStackOverviewChanged,
            ),
          );
        } else {
          // Show loading during the async function finish to process
          return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: SafeArea(child: CircularProgressIndicator()));
        }
      },
    );
  }

  void _handleStackOverviewChanged(
      HabitStack habitStack, bool inOverview, bool toBeDeleted) {
    setState(() {
      // When a user changes what's in the stack, you need
      // to change _habitStack inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.
      print("HabitStackChanged!");
      if (!inOverview) {
        _habitStacks.add(habitStack);
      } else if (toBeDeleted) {
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
            return HabitStackList(onStackOverviewChanged, null);
          },
        );
      },
    );
  }
}
