import 'package:flutter/material.dart';
import 'package:mytone/screens/registration_screen.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don\'t have an account?'),
        TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => RegistrationScreen()));
            },
            child: Text('Sign up', style: TextStyle(color: Color(0xFF7E1CEA))))
      ],
    );
  }
}
