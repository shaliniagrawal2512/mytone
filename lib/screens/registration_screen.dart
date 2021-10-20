import 'package:flutter/material.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:mytone/screens/login_screen.dart';
import 'package:mytone/components/textfield.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/screens/homeScreen.dart';

class RegistrationScreen extends StatelessWidget {
  final Widget space2 = SizedBox(height: 20);
  static const String id = 'registration_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign up',
              style: kHeaderTextStyle,
            ),
            SizedBox(height: 20.0),
            TextInputField(
              label: 'Username',
              obscure: false,
              prefixIcon: Icons.account_circle,
            ),
            TextInputField(
              label: 'Enter Email ID',
              obscure: false,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            TextInputField(
              label: 'Create a Password',
              obscure: true,
              prefixIcon: Icons.lock,
              suffixIcon: Icons.remove_red_eye_sharp,
              onPressed: () {},
            ),
            SizedBox(height: 20.0),
            RaisedGradientButton(
                color: [
                  Color(0xFFF9287B),
                  Color(0xFF7E1CEA),
                ],
                label: 'Create Account',
                icon: Icons.app_registration,
                onPressed: () {
                  Navigator.pushNamed(context, HomeScreen.id);
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    child: Text('Log in'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
