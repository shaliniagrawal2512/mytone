import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  CustomSlider(
      {required this.max, required this.thumbValue, required this.onDragging});
  final double max;
  final Function onDragging;
  final double thumbValue;

  @override
  Widget build(BuildContext context) {
    return Slider(
        value: thumbValue,
        max: max,
        min: 0,
        onChanged: onDragging as void Function(double)?);
  }
}
