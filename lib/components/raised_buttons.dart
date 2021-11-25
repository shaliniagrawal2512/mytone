import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as gradient;

class RaisedGradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Function onPressed;
  final BorderSide? border;
  final List<Color> color;
  RaisedGradientButton({
    required this.color,
    required this.label,
    this.icon,
    this.border,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: gradient.GradientElevatedButton.icon(
        style: gradient.GradientElevatedButton.styleFrom(
            padding: EdgeInsets.all(15.0),
            side: border,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
        gradient: LinearGradient(colors: color),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        onPressed: onPressed as void Function()?,
      ),
    );
  }
}
