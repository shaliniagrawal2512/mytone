import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/text/gradient_text.dart';

import '../constants.dart';

class Header extends StatelessWidget {
  static const String id = 'header';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: GradientText(
          "Header",
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
