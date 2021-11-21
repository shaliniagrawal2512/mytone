import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class CustomSlider extends StatelessWidget {
  CustomSlider(
      {required this.handlerHeight,
      required this.thumbIconSize,
      required this.inactiveTrackHeight,
      required this.trackHeight});
  final double handlerHeight;
  final double thumbIconSize;
  final double trackHeight;
  final double inactiveTrackHeight;

  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      handlerHeight: handlerHeight,
      handler: FlutterSliderHandler(
          disabled: true,
          child: Icon(
            Icons.circle,
            color: Color(0xFFF9287B),
            size: thumbIconSize,
          ),
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  colors: [Color(0xFFFFFDFF), Color(0x29F9287B)],
                  stops: [0.7, 1]),
              shape: BoxShape.circle)),
      values: [0],
      max: 100,
      min: 0,
      trackBar: FlutterSliderTrackBar(
        activeTrackBarHeight: trackHeight,
        inactiveTrackBarHeight: inactiveTrackHeight,
        inactiveTrackBar: BoxDecoration(
          color: Color(0xFF36274A),
        ),
        activeTrackBar: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF7E1CEA),
            Color(0xFFF9287B),
          ]),
        ),
      ),
      onDragging: (handlerIndex, lowerValue, upperValue) {},
    );
  }
}
