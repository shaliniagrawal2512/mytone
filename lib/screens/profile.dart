import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mytone/Services/authentication.dart';
import 'package:mytone/screens/changePassword.dart';
import 'package:mytone/screens/top_screen.dart';

bool showSpinner = false;

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget profileItem(IconData icon, String label, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap as void Function()?,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Container(
          child: Column(
        children: [
          profileItem(Icons.logout, "Log Out", () async {
            setState(() {
              showSpinner = true;
            });
            await Authenticate().logOut();
            setState(() {
              showSpinner = false;
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => TopScreen(),
                ),
                (route) => false);
          }),
          profileItem(Icons.vpn_key, "Change Password", () {
            Navigator.pushNamed(context, ChangePassword.id);
          }),
        ],
      )),
    );
  }
}
