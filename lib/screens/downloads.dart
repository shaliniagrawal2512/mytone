import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/text/gradient_text.dart';
import '../constants.dart';

class Downloads extends StatelessWidget {
  static const String id = 'downloads';
  @override
  Widget build(BuildContext context) {
    TabController? _tController;
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: GradientText(
                  "Downloads",
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF9287B),
                      Color(0xFF7E1CEA),
                    ],
                  ),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                backgroundColor: kBackgroundColor,
                bottom: TabBar(
                    indicatorColor: Color(0xFF7E1CEA),
                    controller: _tController,
                    tabs: [
                      Tab(text: 'Songs'),
                      Tab(text: 'Albums'),
                      Tab(text: 'Artists'),
                      Tab(text: 'Geners')
                    ]))));
  }
}
