import 'package:flutter/material.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/screens/login_screen.dart';
import 'package:mytone/screens/phonenum_screen.dart';
import 'package:mytone/screens/registration_screen.dart';

class TopScreen extends StatelessWidget {
  static const String id = 'top_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Image(
                image: AssetImage("images/mytone.png"),
              ),
            ),
            RaisedGradientButton(
                color: [
                  Color(0xFFF9287B),
                  Color(0xFF7E1CEA),
                ],
                label: 'Sign up',
                icon: Icons.app_registration_sharp,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                }),
            RaisedGradientButton(
                color: [
                  Color(0xFFF9287B),
                  Color(0xFF7E1CEA),
                ],
                label: 'Log in',
                icon: Icons.login_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            RaisedGradientButton(
                color: [
                  kBackgroundColor,
                  kBackgroundColor,
                ],
                label: 'Continue with phone number',
                icon: Icons.smartphone,
                border: BorderSide(color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, PhoneScreen.id);
                }),
          ],
        ),
      ),
    );
  }
}
