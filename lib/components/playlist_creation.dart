import 'package:flutter/material.dart';
import 'package:mytone/components/cardWidget.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';

class PlayList extends StatelessWidget {
  PlayList({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            title,
            gradient: LinearGradient(
              colors: [
                Color(0xFFF9287B),
                Color(0xFF7E1CEA),
              ],
            ),
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 250,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return CardWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}
