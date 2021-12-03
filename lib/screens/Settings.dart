import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/text/gradient_text.dart';
import '../constants.dart';

class Settings extends StatelessWidget {
  static const String id = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: GradientText(
          "Settings",
          gradient: LinearGradient(
            colors: [
              Color(0xFFF9287B),
              Color(0xFF7E1CEA),
            ],
          ),
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kBackgroundColor,
      ),
      body: Container(),
    );
  }
}