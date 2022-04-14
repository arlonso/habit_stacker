import 'package:flutter/material.dart';
import 'package:habit_stacker/utils/constants.dart';

class BorderIcon extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double width;
  final double height;

  const BorderIcon(
      {required this.child,
      this.padding = const EdgeInsets.all(8.0),
      this.height = 60,
      this.width = 60,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: COLOR_WHITE,
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(color: COLOR_GREY.withAlpha(40), width: 2)),
        padding: padding,
        child: Center(child: child));
  }
}
