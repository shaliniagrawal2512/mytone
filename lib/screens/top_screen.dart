import 'package:flutter/material.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/screens/login_screen.dart';
import 'package:mytone/screens/phonenum_screen.dart';
import 'package:mytone/screens/registration_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TopScreen extends StatelessWidget {
  static const String id = 'top_screen';
  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() async {
      bool isExit = false;
      await Alert(
        context: context,
        style: AlertStyle(
            backgroundColor: kBackgroundColor,
            isOverlayTapDismiss: false,
            descStyle: TextStyle(color: Colors.white),
            titleStyle: TextStyle(color: Colors.white)),
        type: AlertType.none,
        title: "Exit",
        desc: "Do u really want to exit the app??",
        buttons: [
          DialogButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              isExit = false;
              Navigator.pop(context);
            },
            color: Color(0xFFF9287B),
            radius: BorderRadius.circular(5.0),
          ),
          DialogButton(
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              isExit = true;
              Navigator.pop(context);
            },
            color: Color(0xFF7E1CEA),
            radius: BorderRadius.circular(5.0),
          ),
        ],
      ).show();
      return isExit;
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
      ),
    );
  }
}
