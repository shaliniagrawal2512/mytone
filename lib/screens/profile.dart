import 'package:flutter/material.dart';
import 'package:mytone/Services/authentication.dart';
import 'package:mytone/screens/top_screen.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        InkWell(
          onTap: () async {
            await Authenticate().logOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => TopScreen(),
                ),
                (route) => false);
          },
          child: Text("Log out"),
        ),
        InkWell(
          onTap: () {},
          child: Text("Change Password"),
        )
      ],
    ));
  }
}
