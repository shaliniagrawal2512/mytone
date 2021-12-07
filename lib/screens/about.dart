import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/text/gradient_text.dart';
import '../constants.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  static const String id = 'about';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: GradientText(
          "About",
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 200,
                child: Image(image: AssetImage('images/mytone.png'))),
            Text('MyTone', style: kSubHeaderTextStyle),
            SizedBox(height: 20),
            Text(
              'This is my Personal project and can be found on',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text('GitHub', style: kSubHeader2TextStyle),
            SizedBox(height: 20),
            InkWell(
                child: new Text('Open Project'),
                onTap: () =>
                    launch('https://github.com/shaliniagrawal2512/mytone')),
            SizedBox(height: 20),
            Text(' Made with ❤ by Shalini Agrawal'),
          ],
        ),
      ),
    );
  }
}
