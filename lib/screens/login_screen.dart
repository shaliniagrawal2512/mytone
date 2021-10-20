import 'package:flutter/material.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:mytone/components/textfield.dart';
import 'registration_screen.dart';
import 'music_player_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login_screen';
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
              'Log in',
              style: kHeaderTextStyle,
            ),
            SizedBox(height: 20.0),
            TextInputField(
              label: 'Enter Email ID',
              obscure: false,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            TextInputField(
              label: 'Enter a Password',
              obscure: true,
              prefixIcon: Icons.lock,
              suffixIcon: Icons.remove_red_eye_sharp,
              onPressed: () {},
            ),
            TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  alignment: Alignment.topRight,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Forget Password',
                )),
            RaisedGradientButton(
                color: [
                  Color(0xFFF9287B),
                  Color(0xFF7E1CEA),
                ],
                label: 'Log in',
                icon: Icons.login_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, MusicPlayer.id);
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                    child: Text('Sign up'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
