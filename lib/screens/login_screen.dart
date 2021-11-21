import 'package:flutter/material.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'registration_screen.dart';

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
            TextField(
              decoration: kInputDecoration.copyWith(
                  hintText: 'Enter Email Address',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  )),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
                obscureText: true,
                decoration: kInputDecoration.copyWith(
                    hintText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconTheme(
                        data: IconThemeData(color: Colors.white),
                        child: IconButton(
                          disabledColor: Colors.grey,
                          icon: Icon(
                            Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        )))),
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
            RaisedGradientButton(color: [
              Color(0xFFF9287B),
              Color(0xFF7E1CEA),
            ], label: 'Log in', icon: Icons.login_rounded, onPressed: () {}),
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
