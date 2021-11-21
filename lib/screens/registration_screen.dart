import 'package:flutter/material.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:mytone/screens/BottomNavigation.dart';
import 'package:mytone/screens/login_screen.dart';
import 'package:mytone/constants.dart';

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
            TextField(
              decoration: kInputDecoration.copyWith(
                  hintText: 'Enter User Name',
                  prefixIcon: Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                  )),
            ),
            SizedBox(height: 10.0),
            TextField(
              decoration: kInputDecoration.copyWith(
                  hintText: 'Enter Email Address',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  )),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10.0),
            TextField(
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
                      ))),
              obscureText: true,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BottomNavigation();
                  }));
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
